<?php
declare(strict_types=1);

// csp disabling javascript
header('Content-Security-Policy: default-src \'self\'; img-src http: https: data:;');

require_once __DIR__ . '/lib/auth.php';
require_once __DIR__ . '/lib/content.php';

$action = $_GET['action'] ?? 'home';
$user = current_user();

function render(string $view, array $vars = []): void
{
    extract($vars);
    $currentUser = current_user();
    require __DIR__ . '/templates/layout/header.php';
    require __DIR__ . '/templates/' . $view . '.php';
    require __DIR__ . '/templates/layout/footer.php';
}

function section_by_slug(string $slug): ?array
{
    $stmt = db()->prepare('SELECT * FROM sections WHERE slug = ?');
    $stmt->execute([$slug]);
    return $stmt->fetch() ?: null;
}

function section_by_id(int $id): ?array
{
    $stmt = db()->prepare('SELECT * FROM sections WHERE id = ?');
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

function all_sections(): array
{
    return db()->query('SELECT * FROM sections ORDER BY id ASC')->fetchAll();
}

function find_thread(int $id): ?array
{
    $stmt = db()->prepare(
        'SELECT t.*, s.slug AS section_slug, s.name AS section_name, u.username
         FROM threads t
         JOIN sections s ON s.id = t.section_id
         JOIN users u ON u.id = t.user_id
         WHERE t.id = ?'
    );
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

function random_upload_name(string $original): string
{
    $ext = pathinfo($original, PATHINFO_EXTENSION);
    $token = bin2hex(random_bytes(12));
    return $token . ($ext ? '.' . strtolower($ext) : '');
}

function find_request_by_uuid(string $uuid): ?array
{
    $stmt = db()->prepare(
        'SELECT jr.*, u.username
         FROM join_requests jr
         JOIN users u ON u.id = jr.user_id
         WHERE jr.request_uuid = ?
         LIMIT 1'
    );
    $stmt->execute([$uuid]);
    return $stmt->fetch() ?: null;
}

switch ($action) {
    case 'register':
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            verify_csrf();
            $username = trim((string) ($_POST['username'] ?? ''));
            $password = (string) ($_POST['password'] ?? '');

            if ($username === '' || $password === '') {
                flash('error', 'Username and password are required.');
                header('Location: index.php?action=register');
                exit;
            }

            try {
                $stmt = db()->prepare('INSERT INTO users (username, password_hash, is_admin, can_post) VALUES (?, ?, 0, 0)');
                $stmt->execute([$username, password_hash($password, PASSWORD_DEFAULT)]);
                flash('success', 'Registered! You can now log in.');
                header('Location: index.php?action=login');
                exit;
            } catch (Throwable $e) {
                flash('error', 'Username already exists.');
                header('Location: index.php?action=register');
                exit;
            }
        }

        render('auth/register');
        break;

    case 'login':
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            verify_csrf();
            $username = trim((string) ($_POST['username'] ?? ''));
            $password = (string) ($_POST['password'] ?? '');

            $stmt = db()->prepare('SELECT * FROM users WHERE username = ?');
            $stmt->execute([$username]);
            $dbUser = $stmt->fetch();

            if (!$dbUser || !password_verify($password, $dbUser['password_hash'])) {
                flash('error', 'Invalid credentials.');
                header('Location: index.php?action=login');
                exit;
            }

            $_SESSION['user_id'] = (int) $dbUser['id'];
            flash('success', 'Welcome back to the snailboard.');
            header('Location: index.php');
            exit;
        }

        render('auth/login');
        break;

    case 'logout':
        session_destroy();
        session_start();
        flash('success', 'Logged out.');
        header('Location: index.php');
        exit;

    case 'join-request':
        require_login();
        $u = current_user();

        if ((int) $u['can_post'] === 1) {
            flash('success', 'You already have posting privileges.');
            header('Location: index.php');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            verify_csrf();
            $contentMd = trim((string) ($_POST['content_markdown'] ?? ''));

            if ($contentMd === '') {
                flash('error', 'Request content is required.');
                header('Location: index.php?action=join-request');
                exit;
            }

            $existing = db()->prepare('SELECT * FROM join_requests WHERE user_id = ? AND status = "pending"');
            $existing->execute([$u['id']]);
            if ($existing->fetch()) {
                flash('error', 'You already have a pending request.');
                header('Location: index.php?action=join-request');
                exit;
            }

            $requestUuid = bin2hex(random_bytes(16));
            $contentHtml = markdown_to_html($contentMd);
            $stmt = db()->prepare(
                'INSERT INTO join_requests (user_id, intro, reason, request_uuid, content_markdown, content_html)
                 VALUES (?, ?, ?, ?, ?, ?)'
            );
            $stmt->execute([$u['id'], '', '', $requestUuid, $contentMd, $contentHtml]);

            flash('success', 'Request sent. View it at: index.php?action=view-request&id=' . $requestUuid);
            header('Location: index.php');
            exit;
        }

        render('join_request');
        break;

    case 'admin-requests':
        require_admin();

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            verify_csrf();
            $requestId = (int) ($_POST['request_id'] ?? 0);
            $decision = (string) ($_POST['decision'] ?? '');
            $note = trim((string) ($_POST['note'] ?? ''));

            $stmt = db()->prepare('SELECT * FROM join_requests WHERE id = ?');
            $stmt->execute([$requestId]);
            $jr = $stmt->fetch();

            if (!$jr || $jr['status'] !== 'pending') {
                flash('error', 'Request not found or already handled.');
                header('Location: index.php?action=admin-requests');
                exit;
            }

            $status = $decision === 'approve' ? 'approved' : 'rejected';
            flash('error', 'Currently, approvals are disabled :((');
            exit;

            $update = db()->prepare('UPDATE join_requests SET status = ?, review_note = ?, reviewed_at = CURRENT_TIMESTAMP WHERE id = ?');
            $update->execute([$status, $note, $requestId]);

            if ($status === 'approved') {
                $grant = db()->prepare('UPDATE users SET can_post = 1 WHERE id = ?');
                $grant->execute([$jr['user_id']]);
            }

            flash('success', 'Request processed.');
            header('Location: index.php?action=admin-requests');
            exit;
        }

        $requests = db()->query(
            'SELECT jr.*, u.username
             FROM join_requests jr
             JOIN users u ON u.id = jr.user_id
             ORDER BY jr.created_at DESC'
        )->fetchAll();

        render('admin_requests', ['requests' => $requests]);
        break;

    case 'view-request':
        $requestUuid = trim((string) ($_GET['id'] ?? ''));
        if (!preg_match('/^[a-f0-9]{32}$/', $requestUuid)) {
            http_response_code(404);
            render('not_found', ['message' => 'Request not found.']);
            break;
        }

        $request = find_request_by_uuid($requestUuid);
        if (!$request) {
            http_response_code(404);
            render('not_found', ['message' => 'Request not found.']);
            break;
        }

        render('view_request', ['request' => $request]);
        break;

    case 'section':
        $slug = (string) ($_GET['slug'] ?? '');
        $section = section_by_slug($slug);

        if (!$section) {
            http_response_code(404);
            render('not_found', ['message' => 'Section not found.']);
            break;
        }

        $stmt = db()->prepare(
            'SELECT t.*, u.username,
                (SELECT COUNT(*) FROM posts p WHERE p.thread_id = t.id) AS post_count,
                (SELECT created_at FROM posts p2 WHERE p2.thread_id = t.id ORDER BY p2.id DESC LIMIT 1) AS last_post_at
             FROM threads t
             JOIN users u ON u.id = t.user_id
             WHERE t.section_id = ?
             ORDER BY t.id DESC'
        );
        $stmt->execute([$section['id']]);
        $threads = $stmt->fetchAll();

        render('section', ['section' => $section, 'threads' => $threads]);
        break;

    case 'new-thread':
        require_login();
        $u = current_user();
        if (!can_user_post($u)) {
            flash('error', 'New users cannot post yet. Send admin request first.');
            header('Location: index.php?action=join-request');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            echo 'Method not allowed.';
            exit;
        }

        verify_csrf();
        $sectionId = (int) ($_POST['section_id'] ?? 0);
        $title = trim((string) ($_POST['title'] ?? ''));
        $contentMd = trim((string) ($_POST['content_markdown'] ?? ''));

        if ($sectionId <= 0 || $title === '' || $contentMd === '') {
            flash('error', 'Section, title and content are required.');
            $section = section_by_id($sectionId);
            $slug = $section['slug'] ?? '';
            header('Location: index.php?action=section&slug=' . urlencode($slug));
            exit;
        }

        $insThread = db()->prepare('INSERT INTO threads (section_id, user_id, title) VALUES (?, ?, ?)');
        $insThread->execute([$sectionId, $u['id'], $title]);
        $threadId = (int) db()->lastInsertId();

        $html = markdown_to_html($contentMd);
        $insPost = db()->prepare('INSERT INTO posts (thread_id, user_id, content_markdown, content_html) VALUES (?, ?, ?, ?)');
        $insPost->execute([$threadId, $u['id'], $contentMd, $html]);

        header('Location: index.php?action=thread&id=' . $threadId);
        exit;

    case 'thread':
        $id = (int) ($_GET['id'] ?? 0);
        $thread = find_thread($id);
        if (!$thread) {
            http_response_code(404);
            render('not_found', ['message' => 'Thread not found.']);
            break;
        }

        $stmt = db()->prepare(
            'SELECT p.*, u.username
             FROM posts p
             JOIN users u ON u.id = p.user_id
             WHERE p.thread_id = ?
             ORDER BY p.id ASC'
        );
        $stmt->execute([$id]);
        $posts = $stmt->fetchAll();

        render('thread', ['thread' => $thread, 'posts' => $posts]);
        break;

    case 'reply':
        require_login();
        $u = current_user();

        if (!can_user_post($u)) {
            flash('error', 'New users cannot post or download attachments until approved.');
            header('Location: index.php?action=join-request');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            echo 'Method not allowed.';
            exit;
        }

        verify_csrf();
        $threadId = (int) ($_POST['thread_id'] ?? 0);
        $contentMd = trim((string) ($_POST['content_markdown'] ?? ''));

        $thread = find_thread($threadId);
        if (!$thread) {
            http_response_code(404);
            render('not_found', ['message' => 'Thread not found.']);
            break;
        }

        if ($contentMd === '') {
            flash('error', 'Reply content is required.');
            header('Location: index.php?action=thread&id=' . $threadId);
            exit;
        }

        $attachmentPath = null;
        $attachmentName = null;

        if (isset($_FILES['attachment']) && is_array($_FILES['attachment']) && (int) $_FILES['attachment']['error'] !== UPLOAD_ERR_NO_FILE) {
            if ((int) $_FILES['attachment']['error'] !== UPLOAD_ERR_OK || (int) $_FILES['attachment']['error'] === UPLOAD_ERR_OK) {
                flash('error', 'Attachment upload failed.');
                header('Location: index.php?action=thread&id=' . $threadId);
                exit;
            }

            if ((int) $_FILES['attachment']['size'] > (2 * 1024 * 1024)) {
                flash('error', 'Attachment too large (max 2MB).');
                header('Location: index.php?action=thread&id=' . $threadId);
                exit;
            }

            $original = (string) $_FILES['attachment']['name'];
            $tmp = (string) $_FILES['attachment']['tmp_name'];
            $safeFile = random_upload_name($original);
            $target = UPLOAD_DIR . '/' . $safeFile;

            if (!move_uploaded_file($tmp, $target)) {
                flash('error', 'Could not save attachment.');
                header('Location: index.php?action=thread&id=' . $threadId);
                exit;
            }

            $attachmentPath = $safeFile;
            $attachmentName = $original;
        }

        $html = markdown_to_html($contentMd);
        $stmt = db()->prepare(
            'INSERT INTO posts (thread_id, user_id, content_markdown, content_html, attachment_path, attachment_original_name)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([$threadId, $u['id'], $contentMd, $html, $attachmentPath, $attachmentName]);

        header('Location: index.php?action=thread&id=' . $threadId);
        exit;

    case 'download':
        require_login();
        $u = current_user();
        if (!can_user_post($u)) {
            http_response_code(403);
            echo '403 Forbidden: New users cannot download attachments.';
            exit;
        }

        $postId = (int) ($_GET['post_id'] ?? 0);
        $stmt = db()->prepare('SELECT attachment_path, attachment_original_name FROM posts WHERE id = ?');
        $stmt->execute([$postId]);
        $post = $stmt->fetch();

        if (!$post || !$post['attachment_path']) {
            http_response_code(404);
            echo 'Attachment not found.';
            exit;
        }

        $path = UPLOAD_DIR . '/' . $post['attachment_path'];
        if (!is_file($path)) {
            http_response_code(404);
            echo 'Attachment missing on server.';
            exit;
        }

        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . basename((string) $post['attachment_original_name']) . '"');
        header('Content-Length: ' . filesize($path));
        readfile($path);
        exit;

    case 'search':
        $q = trim((string) ($_GET['q'] ?? ''));
        $results = [];

        if ($q !== '') {
            $stmt = db()->prepare(
                'SELECT DISTINCT t.id, t.title, s.slug AS section_slug
                 FROM threads t
                 JOIN sections s ON s.id = t.section_id
                 LEFT JOIN posts p ON p.thread_id = t.id
                 WHERE t.title LIKE :q OR p.content_markdown LIKE :q
                 ORDER BY t.id DESC'
            );
            $stmt->execute(['q' => '%' . $q . '%']);
            $results = $stmt->fetchAll();
        }

        if (count($results) === 0) {
            http_response_code(404);
        } else {
            http_response_code(200);
        }

        render('search', ['query' => $q, 'results' => $results]);
        break;

    case 'home':
    default:
        $sections = all_sections();
        render('home', ['sections' => $sections]);
        break;
}

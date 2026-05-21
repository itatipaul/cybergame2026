<?php
declare(strict_types=1);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

const DATA_DIR = __DIR__ . '/../data';
const UPLOAD_DIR = __DIR__ . '/../uploads';

if (!is_dir(DATA_DIR)) {
    mkdir(DATA_DIR, 0775, true);
}

if (!is_dir(UPLOAD_DIR)) {
    mkdir(UPLOAD_DIR, 0775, true);
}

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $pdo = new PDO('sqlite:' . DATA_DIR . '/forum.sqlite');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    initialize_schema($pdo);
    seed_defaults($pdo);

    return $pdo;
}

function initialize_schema(PDO $pdo): void
{
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            is_admin INTEGER NOT NULL DEFAULT 0,
            can_post INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )'
    );

    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS join_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            intro TEXT NOT NULL,
            reason TEXT NOT NULL,
            request_uuid TEXT UNIQUE,
            content_markdown TEXT,
            content_html TEXT,
            status TEXT NOT NULL DEFAULT "pending",
            review_note TEXT,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            reviewed_at TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )'
    );

    ensure_join_request_columns($pdo);

    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS sections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            slug TEXT UNIQUE NOT NULL,
            name TEXT NOT NULL,
            language_label TEXT NOT NULL,
            description TEXT NOT NULL
        )'
    );

    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS threads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            section_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (section_id) REFERENCES sections (id),
            FOREIGN KEY (user_id) REFERENCES users (id)
        )'
    );

    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            thread_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            content_markdown TEXT NOT NULL,
            content_html TEXT NOT NULL,
            attachment_path TEXT,
            attachment_original_name TEXT,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (thread_id) REFERENCES threads (id),
            FOREIGN KEY (user_id) REFERENCES users (id)
        )'
    );
}

function ensure_join_request_columns(PDO $pdo): void
{
    $columns = $pdo->query('PRAGMA table_info(join_requests)')->fetchAll();
    $names = [];
    foreach ($columns as $column) {
        if (isset($column['name'])) {
            $names[] = (string) $column['name'];
        }
    }

    if (!in_array('request_uuid', $names, true)) {
        $pdo->exec('ALTER TABLE join_requests ADD COLUMN request_uuid TEXT');
    }

    if (!in_array('content_markdown', $names, true)) {
        $pdo->exec('ALTER TABLE join_requests ADD COLUMN content_markdown TEXT');
    }

    if (!in_array('content_html', $names, true)) {
        $pdo->exec('ALTER TABLE join_requests ADD COLUMN content_html TEXT');
    }

    $rows = $pdo->query('SELECT id, intro, reason, request_uuid, content_markdown, content_html FROM join_requests')->fetchAll();
    $update = $pdo->prepare(
        'UPDATE join_requests
         SET request_uuid = ?, content_markdown = ?, content_html = ?
         WHERE id = ?'
    );

    foreach ($rows as $row) {
        $uuid = (string) ($row['request_uuid'] ?? '');
        $markdown = (string) ($row['content_markdown'] ?? '');
        $html = (string) ($row['content_html'] ?? '');

        if ($uuid === '') {
            $uuid = bin2hex(random_bytes(16));
        }

        if ($markdown === '') {
            $intro = trim((string) ($row['intro'] ?? ''));
            $reason = trim((string) ($row['reason'] ?? ''));
            $markdown = "## Intro\n\n" . $intro . "\n\n## Reason\n\n" . $reason;
        }

        if ($html === '') {
            $html = markdown_to_html_for_seed($markdown);
        }

        $update->execute([$uuid, $markdown, $html, (int) $row['id']]);
    }
}

function seed_defaults(PDO $pdo): void
{
    $adminCheck = $pdo->query('SELECT COUNT(*) AS c FROM users WHERE is_admin = 1')->fetch();
    if ((int) ($adminCheck['c'] ?? 0) === 0) {
        $stmt = $pdo->prepare('INSERT INTO users (username, password_hash, is_admin, can_post) VALUES (?, ?, 1, 1)');
        $stmt->execute([
            'admin',
            password_hash('admin123', PASSWORD_DEFAULT),
        ]);
    }

    $sectionCount = $pdo->query('SELECT COUNT(*) AS c FROM sections')->fetch();
    if ((int) ($sectionCount['c'] ?? 0) === 0) {
        $stmt = $pdo->prepare('INSERT INTO sections (slug, name, language_label, description) VALUES (?, ?, ?, ?)');
        $seed = [
            ['slovak', 'Slimáky SK', 'Slovak', 'Diskusia o slimákoch po slovensky.'],
            ['australian', 'Snail Cobber Corner', 'Australian', 'Aussie snail sightings, backyard legends, and matey banter.'],
            ['kenyan', 'Snail Kenya Board', 'Kenyan', 'Stories about snails from Kenya and East Africa.'],
        ];

        foreach ($seed as $row) {
            $stmt->execute($row);
        }
    }

    $threadCount = $pdo->query('SELECT COUNT(*) AS c FROM threads')->fetch();
    if ((int) ($threadCount['c'] ?? 0) === 0) {
        $userStmt = $pdo->query("SELECT id FROM users WHERE username = 'admin' LIMIT 1");
        $admin = $userStmt->fetch();
        $sectionStmt = $pdo->query("SELECT id FROM sections WHERE slug = 'slovak' LIMIT 1");
        $section = $sectionStmt->fetch();

        if ($admin && $section) {
            $pdo->prepare('INSERT INTO threads (section_id, user_id, title) VALUES (?, ?, ?)')
                ->execute([(int) $section['id'], (int) $admin['id'], 'Vitajte na slimáčom fóre']);

            $threadId = (int) $pdo->lastInsertId();
            $welcome = "# Vitajte\n\nToto je prvé vlákno o slimákoch. Podeľte sa o fotky, záhradné tipy, pozorovania po daždi a starú dobrú fórum energiu. :)";
            $pdo->prepare('INSERT INTO posts (thread_id, user_id, content_markdown, content_html) VALUES (?, ?, ?, ?)')
                ->execute([
                    $threadId,
                    (int) $admin['id'],
                    $welcome,
                    markdown_to_html_for_seed($welcome),
                ]);
        }
    }

    require_once __DIR__ . '/seed_large_forum.php';
    seed_large_forum_content($pdo);
}

function markdown_to_html_for_seed(string $markdown): string
{
    require_once __DIR__ . '/content.php';
    return markdown_to_html($markdown);
}

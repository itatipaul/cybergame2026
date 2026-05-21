<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

function h(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function current_user(): ?array
{
    if (!isset($_SESSION['user_id'])) {
        return null;
    }

    static $cachedUser = null;
    if ($cachedUser !== null && (int) $cachedUser['id'] === (int) $_SESSION['user_id']) {
        return $cachedUser;
    }

    $stmt = db()->prepare('SELECT * FROM users WHERE id = ?');
    $stmt->execute([$_SESSION['user_id']]);
    $user = $stmt->fetch();

    if (!$user) {
        unset($_SESSION['user_id']);
        return null;
    }

    $cachedUser = $user;
    return $cachedUser;
}

function require_login(): void
{
    if (!current_user()) {
        $_SESSION['flash_error'] = 'Please log in first.';
        header('Location: index.php?action=login');
        exit;
    }
}

function require_admin(): void
{
    $user = current_user();
    if (!$user || (int) $user['is_admin'] !== 1) {
        http_response_code(403);
        echo '403 Forbidden';
        exit;
    }
}

function can_user_post(array $user): bool
{
    return (int) ($user['can_post'] ?? 0) === 1;
}

function csrf_token(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(24));
    }

    return $_SESSION['csrf_token'];
}

function verify_csrf(): void
{
    $provided = $_POST['csrf_token'] ?? '';
    $actual = $_SESSION['csrf_token'] ?? '';
    if (!$provided || !$actual || !hash_equals($actual, $provided)) {
        http_response_code(400);
        echo 'Bad CSRF token.';
        exit;
    }
}

function flash(string $key, string $message): void
{
    $_SESSION['flash_' . $key] = $message;
}

function get_flash(string $key): ?string
{
    $sessionKey = 'flash_' . $key;
    if (!isset($_SESSION[$sessionKey])) {
        return null;
    }

    $value = $_SESSION[$sessionKey];
    unset($_SESSION[$sessionKey]);
    return $value;
}

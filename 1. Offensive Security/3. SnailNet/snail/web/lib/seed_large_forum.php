<?php
declare(strict_types=1);

/**
 * Minimal handout seed data.
 *
 * Keeps the same API as deploy, but avoids shipping a massive seed dataset.
 */
function seed_large_forum_content(PDO $pdo): void
{
    $markerFile = DATA_DIR . '/seed_large_forum_handout.done';
    if (is_file($markerFile)) {
        return;
    }

    $sections = seed_large_forum_get_section_ids($pdo);
    if (!isset($sections['australian'], $sections['slovak'], $sections['kenyan'])) {
        return;
    }

    $pdo->beginTransaction();
    try {
        $users = ['EngyCZ', 'mlb', 'Chris Redfield'];
        seed_large_forum_ensure_users($pdo, $users, password_hash('snailtime', PASSWORD_DEFAULT));
        $userIds = seed_large_forum_get_user_ids($pdo, $users);

        $adminRow = $pdo->query("SELECT id FROM users WHERE username = 'admin' LIMIT 1")->fetch();
        if ($adminRow && isset($adminRow['id'])) {
            $userIds['admin'] = (int) $adminRow['id'];
        }

        seed_large_forum_insert_threads(
            $pdo,
            (int) $sections['australian'],
            [
                [
                    'title' => 'Backyard snail watch',
                    'posts' => [
                        ['u' => 'EngyCZ', 'md' => "Spotted 3 snails after rain yesterday.\n\nAny tips for keeping them away from lettuce?"],
                        ['u' => 'admin', 'md' => "Try watering in the morning and use rough mulch around seedlings."],
                    ],
                ],
            ],
            $userIds,
            7
        );

        seed_large_forum_insert_threads(
            $pdo,
            (int) $sections['slovak'],
            [
                [
                    'title' => 'Slimaky po dazdi',
                    'posts' => [
                        ['u' => 'mlb', 'md' => "Vcera po dazdi ich bolo vsade plno.\n\nMate nejake overene triky do zahrady?"],
                        ['u' => 'admin', 'md' => "Pomaha pravidelne upratovanie listov a jemny strk okolo zahonov."],
                    ],
                ],
            ],
            $userIds,
            7
        );

        seed_large_forum_insert_threads(
            $pdo,
            (int) $sections['kenyan'],
            [
                [
                    'title' => 'Snails after evening rain',
                    'posts' => [
                        ['u' => 'Chris Redfield', 'md' => "They come out near the fence every evening.\n\nI am tracking where they gather."],
                        ['u' => 'admin', 'md' => "Nice! Share photos and notes in this thread."],
                    ],
                ],
            ],
            $userIds,
            7
        );

        $pdo->commit();
        @file_put_contents($markerFile, 'seeded ' . date('c'));
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function seed_large_forum_get_section_ids(PDO $pdo): array
{
    $rows = $pdo->query('SELECT id, slug FROM sections')->fetchAll();
    $out = [];

    foreach ($rows as $row) {
        if (!isset($row['id'], $row['slug'])) {
            continue;
        }
        $out[(string) $row['slug']] = (int) $row['id'];
    }

    return $out;
}

function seed_large_forum_ensure_users(PDO $pdo, array $usernames, string $passwordHash): void
{
    $ins = $pdo->prepare('INSERT OR IGNORE INTO users (username, password_hash, is_admin, can_post) VALUES (?, ?, 0, 1)');

    foreach ($usernames as $username) {
        $u = trim((string) $username);
        if ($u === '') {
            continue;
        }
        $ins->execute([$u, $passwordHash]);
    }

    $filtered = [];
    foreach ($usernames as $username) {
        $u = trim((string) $username);
        if ($u !== '') {
            $filtered[] = $u;
        }
    }

    if (count($filtered) === 0) {
        return;
    }

    $placeholders = implode(',', array_fill(0, count($filtered), '?'));
    $pdo->prepare('UPDATE users SET can_post = 1 WHERE username IN (' . $placeholders . ')')->execute($filtered);
}

function seed_large_forum_get_user_ids(PDO $pdo, array $usernames): array
{
    $filtered = [];
    foreach ($usernames as $username) {
        $u = trim((string) $username);
        if ($u !== '') {
            $filtered[] = $u;
        }
    }

    if (count($filtered) === 0) {
        return [];
    }

    $placeholders = implode(',', array_fill(0, count($filtered), '?'));
    $stmt = $pdo->prepare('SELECT id, username FROM users WHERE username IN (' . $placeholders . ')');
    $stmt->execute($filtered);

    $out = [];
    foreach ($stmt->fetchAll() as $row) {
        if (!isset($row['id'], $row['username'])) {
            continue;
        }
        $out[(string) $row['username']] = (int) $row['id'];
    }

    return $out;
}

function seed_large_forum_existing_thread_titles(PDO $pdo, int $sectionId): array
{
    $stmt = $pdo->prepare('SELECT title FROM threads WHERE section_id = ?');
    $stmt->execute([$sectionId]);
    $rows = $stmt->fetchAll();

    $out = [];
    foreach ($rows as $row) {
        if (!isset($row['title'])) {
            continue;
        }
        $out[(string) $row['title']] = true;
    }

    return $out;
}

function seed_large_forum_insert_threads(PDO $pdo, int $sectionId, array $threads, array $userIds, int $maxDaysBack): void
{
    $insThread = $pdo->prepare('INSERT INTO threads (section_id, user_id, title, created_at) VALUES (?, ?, ?, ?)');
    $insPost = $pdo->prepare('INSERT INTO posts (thread_id, user_id, content_markdown, content_html, created_at) VALUES (?, ?, ?, ?, ?)');

    $existingTitles = seed_large_forum_existing_thread_titles($pdo, $sectionId);
    $threadCount = count($threads);

    foreach ($threads as $threadIndex => $thread) {
        $title = trim((string) ($thread['title'] ?? ''));
        $posts = $thread['posts'] ?? [];

        if ($title === '' || !is_array($posts) || count($posts) === 0) {
            continue;
        }

        if (isset($existingTitles[$title])) {
            continue;
        }
        $existingTitles[$title] = true;

        $firstUser = (string) (($posts[0]['u'] ?? '') ?: 'admin');
        $threadUserId = (int) ($userIds[$firstUser] ?? ($userIds['admin'] ?? 1));

        $threadStartTs = seed_large_forum_thread_start_ts((int) $threadIndex, $threadCount, $maxDaysBack);
        $threadCreatedAt = date('Y-m-d H:i:s', $threadStartTs);

        $insThread->execute([$sectionId, $threadUserId, $title, $threadCreatedAt]);
        $threadId = (int) $pdo->lastInsertId();

        foreach ($posts as $postIndex => $post) {
            $u = (string) (($post['u'] ?? '') ?: 'admin');
            $md = trim((string) ($post['md'] ?? ''));
            if ($md === '') {
                continue;
            }

            $userId = (int) ($userIds[$u] ?? ($userIds['admin'] ?? 1));
            $postTs = $threadStartTs + ((int) $postIndex * 2400) + ((int) $postIndex % 5) * 91;
            $createdAt = date('Y-m-d H:i:s', $postTs);

            $html = markdown_to_html_for_seed($md);
            $insPost->execute([$threadId, $userId, $md, $html, $createdAt]);
        }
    }
}

function seed_large_forum_thread_start_ts(int $threadIndex, int $threadCount, int $maxDaysBack): int
{
    $daysBack = (int) (($threadCount - $threadIndex) * $maxDaysBack / max($threadCount, 1));
    $daysBack += ($threadIndex % 5);

    $base = time() - ($daysBack * 86400);
    $hour = 7 + ($threadIndex % 11);
    $minute = (17 * $threadIndex) % 60;
    $second = (11 * $threadIndex) % 60;

    return strtotime(date('Y-m-d', $base) . sprintf(' %02d:%02d:%02d', $hour, $minute, $second)) ?: $base;
}

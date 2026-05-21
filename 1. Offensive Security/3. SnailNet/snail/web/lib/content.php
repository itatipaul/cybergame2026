<?php
declare(strict_types=1);

function safe_markdown_url(string $url): string
{
    $trimmed = trim($url);
    if ($trimmed === '') {
        return '#';
    }

    if (preg_match('~^(https?://|/uploads/)~i', $trimmed)) {
        return htmlspecialchars($trimmed, ENT_QUOTES, 'UTF-8');
    }

    return '#';
}

function apply_forum_emojis(string $html): string
{
    $map = [
        ':-)' => '<span class="og-emoji">:-)</span>',
        ':)' => '<span class="og-emoji">:)</span>',
        ':-D' => '<span class="og-emoji">:-D</span>',
        ':D' => '<span class="og-emoji">:D</span>',
        ';-)' => '<span class="og-emoji">;-)</span>',
        ';)' => '<span class="og-emoji">;)</span>',
        ':-(' => '<span class="og-emoji">:-(</span>',
        ':(' => '<span class="og-emoji">:(</span>',
        ':P' => '<span class="og-emoji">:P</span>',
        ':-P' => '<span class="og-emoji">:-P</span>',
    ];

    return strtr($html, $map);
}

function markdown_to_html(string $markdown): string
{
    $text = str_replace(["\r\n", "\r"], "\n", trim($markdown));
    $text = htmlspecialchars($text, ENT_QUOTES, 'UTF-8');

    $text = preg_replace('/^######\s+(.*)$/m', '<h6>$1</h6>', $text);
    $text = preg_replace('/^#####\s+(.*)$/m', '<h5>$1</h5>', $text);
    $text = preg_replace('/^####\s+(.*)$/m', '<h4>$1</h4>', $text);
    $text = preg_replace('/^###\s+(.*)$/m', '<h3>$1</h3>', $text);
    $text = preg_replace('/^##\s+(.*)$/m', '<h2>$1</h2>', $text);
    $text = preg_replace('/^#\s+(.*)$/m', '<h1>$1</h1>', $text);

    $text = preg_replace('/\*\*(.*?)\*\*/s', '<strong>$1</strong>', $text);
    $text = preg_replace('/\*(.*?)\*/s', '<em>$1</em>', $text);
    $text = preg_replace('/`([^`]+)`/', '<code>$1</code>', $text);

    $text = preg_replace_callback('/!\[(.*?)\]\((.*?)\)/', static function (array $m): string {
        $alt = htmlspecialchars($m[1], ENT_QUOTES, 'UTF-8');
        $url = safe_markdown_url(htmlspecialchars_decode($m[2], ENT_QUOTES));
        return '<img src="' . $url . '" alt="' . $alt . '" class="post-image">';
    }, $text);

    $text = preg_replace_callback('/\[(.*?)\]\((.*?)\)/', static function (array $m): string {
        $label = htmlspecialchars($m[1], ENT_QUOTES, 'UTF-8');
        $url = safe_markdown_url(htmlspecialchars_decode($m[2], ENT_QUOTES));
        return '<a href="' . $url . '" target="_blank" rel="noopener noreferrer">' . $label . '</a>';
    }, $text);

    $chunks = preg_split('/\n\s*\n/', $text) ?: [];
    $final = [];

    foreach ($chunks as $chunk) {
        $trim = trim($chunk);
        if ($trim === '') {
            continue;
        }

        if (preg_match('/^<h[1-6]>.*<\/h[1-6]>$/s', $trim)) {
            $final[] = $trim;
            continue;
        }

        $final[] = '<p>' . nl2br($trim) . '</p>';
    }

    return apply_forum_emojis(implode("\n", $final));
}

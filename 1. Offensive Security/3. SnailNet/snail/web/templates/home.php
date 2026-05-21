<section class="panel">
    <h1>SnailNet 1998</h1>
    <p>The internet's loudest snail forum, now with three language sections and old-school chaos.</p>
</section>

<section class="panel">
    <h2>Forum Sections</h2>
    <div class="section-grid">
        <?php foreach ($sections as $section): ?>
            <article class="section-card">
                <h3><?= h($section['name']) ?></h3>
                <p><strong>Language:</strong> <?= h($section['language_label']) ?></p>
                <p><?= h($section['description']) ?></p>
                <a class="button" href="index.php?action=section&amp;slug=<?= urlencode($section['slug']) ?>">Enter Board</a>
            </article>
        <?php endforeach; ?>
    </div>
</section>

<section class="panel tips">
    <h2>New Users</h2>
    <p>Fresh accounts cannot post or download attachments until admin approval.</p>
    <p>Send a request introducing yourself and explaining why you belong here.</p>
</section>

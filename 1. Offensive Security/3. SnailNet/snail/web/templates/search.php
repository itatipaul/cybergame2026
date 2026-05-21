<section class="panel">
    <h1>Search SnailNet (GET)</h1>
    <form method="get" action="index.php">
        <input type="hidden" name="action" value="search">
        <label>Search query</label>
        <input type="text" name="q" value="<?= h((string) ($query ?? '')) ?>" required>
        <button class="button" type="submit">Search</button>
    </form>
</section>

<section class="panel">
    <h2>Results</h2>
    <?php if (empty($results)): ?>
        <p>No results found for "<?= h((string) ($query ?? '')) ?>". HTTP status is 404.</p>
    <?php else: ?>
        <p>Found <?= count($results) ?> result(s). HTTP status is 200.</p>
        <ul class="search-results">
            <?php foreach ($results as $row): ?>
                <li>
                    <a href="index.php?action=thread&amp;id=<?= (int) $row['id'] ?>"><?= h($row['title']) ?></a>
                    <small>(Section: <?= h($row['section_slug']) ?>)</small>
                </li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</section>

<section class="panel">
    <h1>Request Posting Privileges</h1>
    <p>Write your request in markdown. This page can be shared via a public UUID link.</p>

    <form method="post" action="index.php?action=join-request">
        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">

        <label>Request (markdown)</label>
        <textarea name="content_markdown" rows="10" required></textarea>

        <button class="button" type="submit">Send To Admin</button>
    </form>
</section>

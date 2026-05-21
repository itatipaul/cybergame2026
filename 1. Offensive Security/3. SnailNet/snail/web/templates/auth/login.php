<section class="panel auth-box">
    <h1>Login</h1>
    <form method="post" action="index.php?action=login">
        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button class="button" type="submit">Enter SnailNet</button>
    </form>
</section>

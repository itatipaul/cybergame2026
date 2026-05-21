<section class="panel auth-box">
    <h1>Register</h1>
    <p>All new accounts start in read-only mode until approved by admin.</p>

    <form method="post" action="index.php?action=register">
        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button class="button" type="submit">Create Account</button>
    </form>
</section>

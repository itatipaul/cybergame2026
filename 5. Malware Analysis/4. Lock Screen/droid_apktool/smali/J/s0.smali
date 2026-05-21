.class public LJ/s0;
.super LJ/r0;
.source "SourceFile"


# instance fields
.field public m:LB/d;


# direct methods
.method public constructor <init>(LJ/y0;Landroid/view/WindowInsets;)V
    .locals 0

    invoke-direct {p0, p1, p2}, LJ/r0;-><init>(LJ/y0;Landroid/view/WindowInsets;)V

    const/4 p1, 0x0

    iput-object p1, p0, LJ/s0;->m:LB/d;

    return-void
.end method


# virtual methods
.method public b()LJ/y0;
    .locals 2

    iget-object v0, p0, LJ/r0;->c:Landroid/view/WindowInsets;

    invoke-virtual {v0}, Landroid/view/WindowInsets;->consumeStableInsets()Landroid/view/WindowInsets;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v1, v0}, LJ/y0;->g(Landroid/view/View;Landroid/view/WindowInsets;)LJ/y0;

    move-result-object v0

    return-object v0
.end method

.method public c()LJ/y0;
    .locals 2

    iget-object v0, p0, LJ/r0;->c:Landroid/view/WindowInsets;

    invoke-virtual {v0}, Landroid/view/WindowInsets;->consumeSystemWindowInsets()Landroid/view/WindowInsets;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v1, v0}, LJ/y0;->g(Landroid/view/View;Landroid/view/WindowInsets;)LJ/y0;

    move-result-object v0

    return-object v0
.end method

.method public final h()LB/d;
    .locals 4

    iget-object v0, p0, LJ/s0;->m:LB/d;

    if-nez v0, :cond_0

    iget-object v0, p0, LJ/r0;->c:Landroid/view/WindowInsets;

    invoke-virtual {v0}, Landroid/view/WindowInsets;->getStableInsetLeft()I

    move-result v1

    invoke-virtual {v0}, Landroid/view/WindowInsets;->getStableInsetTop()I

    move-result v2

    invoke-virtual {v0}, Landroid/view/WindowInsets;->getStableInsetRight()I

    move-result v3

    invoke-virtual {v0}, Landroid/view/WindowInsets;->getStableInsetBottom()I

    move-result v0

    invoke-static {v1, v2, v3, v0}, LB/d;->b(IIII)LB/d;

    move-result-object v0

    iput-object v0, p0, LJ/s0;->m:LB/d;

    :cond_0
    iget-object v0, p0, LJ/s0;->m:LB/d;

    return-object v0
.end method

.method public m()Z
    .locals 1

    iget-object v0, p0, LJ/r0;->c:Landroid/view/WindowInsets;

    invoke-virtual {v0}, Landroid/view/WindowInsets;->isConsumed()Z

    move-result v0

    return v0
.end method

.method public q(LB/d;)V
    .locals 0

    iput-object p1, p0, LJ/s0;->m:LB/d;

    return-void
.end method

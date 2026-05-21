.class public final Lm/d;
.super Lm/e;
.source "SourceFile"

# interfaces
.implements Ljava/util/Iterator;


# instance fields
.field public a:Lm/c;

.field public b:Z

.field public final synthetic c:Lm/f;


# direct methods
.method public constructor <init>(Lm/f;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lm/d;->c:Lm/f;

    const/4 p1, 0x1

    iput-boolean p1, p0, Lm/d;->b:Z

    return-void
.end method


# virtual methods
.method public final a(Lm/c;)V
    .locals 1

    iget-object v0, p0, Lm/d;->a:Lm/c;

    if-ne p1, v0, :cond_1

    iget-object p1, v0, Lm/c;->d:Lm/c;

    iput-object p1, p0, Lm/d;->a:Lm/c;

    if-nez p1, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    iput-boolean p1, p0, Lm/d;->b:Z

    :cond_1
    return-void
.end method

.method public final hasNext()Z
    .locals 3

    iget-boolean v0, p0, Lm/d;->b:Z

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    iget-object v0, p0, Lm/d;->c:Lm/f;

    iget-object v0, v0, Lm/f;->a:Lm/c;

    if-eqz v0, :cond_0

    move v1, v2

    :cond_0
    return v1

    :cond_1
    iget-object v0, p0, Lm/d;->a:Lm/c;

    if-eqz v0, :cond_2

    iget-object v0, v0, Lm/c;->c:Lm/c;

    if-eqz v0, :cond_2

    move v1, v2

    :cond_2
    return v1
.end method

.method public final next()Ljava/lang/Object;
    .locals 1

    iget-boolean v0, p0, Lm/d;->b:Z

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    iput-boolean v0, p0, Lm/d;->b:Z

    iget-object v0, p0, Lm/d;->c:Lm/f;

    iget-object v0, v0, Lm/f;->a:Lm/c;

    iput-object v0, p0, Lm/d;->a:Lm/c;

    goto :goto_1

    :cond_0
    iget-object v0, p0, Lm/d;->a:Lm/c;

    if-eqz v0, :cond_1

    iget-object v0, v0, Lm/c;->c:Lm/c;

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    iput-object v0, p0, Lm/d;->a:Lm/c;

    :goto_1
    iget-object v0, p0, Lm/d;->a:Lm/c;

    return-object v0
.end method

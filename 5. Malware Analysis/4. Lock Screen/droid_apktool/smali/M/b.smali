.class public final Lm/b;
.super Lm/e;
.source "SourceFile"

# interfaces
.implements Ljava/util/Iterator;


# instance fields
.field public a:Lm/c;

.field public b:Lm/c;

.field public final synthetic c:I


# direct methods
.method public constructor <init>(Lm/c;Lm/c;I)V
    .locals 0

    iput p3, p0, Lm/b;->c:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p2, p0, Lm/b;->a:Lm/c;

    iput-object p1, p0, Lm/b;->b:Lm/c;

    return-void
.end method


# virtual methods
.method public final a(Lm/c;)V
    .locals 2

    iget-object v0, p0, Lm/b;->a:Lm/c;

    const/4 v1, 0x0

    if-ne v0, p1, :cond_0

    iget-object v0, p0, Lm/b;->b:Lm/c;

    if-ne p1, v0, :cond_0

    iput-object v1, p0, Lm/b;->b:Lm/c;

    iput-object v1, p0, Lm/b;->a:Lm/c;

    :cond_0
    iget-object v0, p0, Lm/b;->a:Lm/c;

    if-ne v0, p1, :cond_1

    invoke-virtual {p0, v0}, Lm/b;->b(Lm/c;)Lm/c;

    move-result-object v0

    iput-object v0, p0, Lm/b;->a:Lm/c;

    :cond_1
    iget-object v0, p0, Lm/b;->b:Lm/c;

    if-ne v0, p1, :cond_4

    iget-object p1, p0, Lm/b;->a:Lm/c;

    if-eq v0, p1, :cond_3

    if-nez p1, :cond_2

    goto :goto_0

    :cond_2
    invoke-virtual {p0, v0}, Lm/b;->c(Lm/c;)Lm/c;

    move-result-object v1

    :cond_3
    :goto_0
    iput-object v1, p0, Lm/b;->b:Lm/c;

    :cond_4
    return-void
.end method

.method public final b(Lm/c;)Lm/c;
    .locals 1

    iget v0, p0, Lm/b;->c:I

    packed-switch v0, :pswitch_data_0

    iget-object p1, p1, Lm/c;->c:Lm/c;

    return-object p1

    :pswitch_0
    iget-object p1, p1, Lm/c;->d:Lm/c;

    return-object p1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final c(Lm/c;)Lm/c;
    .locals 1

    iget v0, p0, Lm/b;->c:I

    packed-switch v0, :pswitch_data_0

    iget-object p1, p1, Lm/c;->d:Lm/c;

    return-object p1

    :pswitch_0
    iget-object p1, p1, Lm/c;->c:Lm/c;

    return-object p1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final hasNext()Z
    .locals 1

    iget-object v0, p0, Lm/b;->b:Lm/c;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public final next()Ljava/lang/Object;
    .locals 2

    iget-object v0, p0, Lm/b;->b:Lm/c;

    iget-object v1, p0, Lm/b;->a:Lm/c;

    if-eq v0, v1, :cond_1

    if-nez v1, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0, v0}, Lm/b;->c(Lm/c;)Lm/c;

    move-result-object v1

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v1, 0x0

    :goto_1
    iput-object v1, p0, Lm/b;->b:Lm/c;

    return-object v0
.end method

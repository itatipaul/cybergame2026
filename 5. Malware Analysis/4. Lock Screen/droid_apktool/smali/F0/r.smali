.class public final Lf0/r;
.super Lf0/n;
.source "SourceFile"


# instance fields
.field public final synthetic a:I

.field public b:Lf0/m;


# direct methods
.method public synthetic constructor <init>()V
    .locals 1

    .line 1
    const/4 v0, 0x1

    iput v0, p0, Lf0/r;->a:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public constructor <init>(Lf0/m;)V
    .locals 1

    const/4 v0, 0x0

    iput v0, p0, Lf0/r;->a:I

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 3
    iput-object p1, p0, Lf0/r;->b:Lf0/m;

    return-void
.end method


# virtual methods
.method public final b(Lf0/m;)V
    .locals 2

    iget v0, p0, Lf0/r;->a:I

    packed-switch v0, :pswitch_data_0

    iget-object v0, p0, Lf0/r;->b:Lf0/m;

    check-cast v0, Lf0/a;

    iget v1, v0, Lf0/a;->C:I

    add-int/lit8 v1, v1, -0x1

    iput v1, v0, Lf0/a;->C:I

    if-nez v1, :cond_0

    const/4 v1, 0x0

    iput-boolean v1, v0, Lf0/a;->D:Z

    invoke-virtual {v0}, Lf0/m;->m()V

    :cond_0
    invoke-virtual {p1, p0}, Lf0/m;->x(Lf0/k;)Lf0/m;

    return-void

    :pswitch_0
    iget-object v0, p0, Lf0/r;->b:Lf0/m;

    invoke-virtual {v0}, Lf0/m;->z()V

    invoke-virtual {p1, p0}, Lf0/m;->x(Lf0/k;)Lf0/m;

    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public c(Lf0/m;)V
    .locals 1

    iget p1, p0, Lf0/r;->a:I

    packed-switch p1, :pswitch_data_0

    return-void

    :pswitch_0
    iget-object p1, p0, Lf0/r;->b:Lf0/m;

    check-cast p1, Lf0/a;

    iget-boolean v0, p1, Lf0/a;->D:Z

    if-nez v0, :cond_0

    invoke-virtual {p1}, Lf0/m;->G()V

    const/4 v0, 0x1

    iput-boolean v0, p1, Lf0/a;->D:Z

    :cond_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
    .end packed-switch
.end method

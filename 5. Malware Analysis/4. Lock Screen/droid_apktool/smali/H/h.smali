.class public abstract LH/h;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:LH/g;

.field public static final b:LH/g;

.field public static final c:LH/g;

.field public static final d:LH/g;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    new-instance v0, LH/g;

    const/4 v1, 0x0

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, LH/g;-><init>(LH/f;Z)V

    sput-object v0, LH/h;->a:LH/g;

    new-instance v0, LH/g;

    const/4 v3, 0x1

    invoke-direct {v0, v1, v3}, LH/g;-><init>(LH/f;Z)V

    sput-object v0, LH/h;->b:LH/g;

    new-instance v0, LH/g;

    sget-object v1, LH/f;->a:LH/f;

    invoke-direct {v0, v1, v2}, LH/g;-><init>(LH/f;Z)V

    sput-object v0, LH/h;->c:LH/g;

    new-instance v0, LH/g;

    invoke-direct {v0, v1, v3}, LH/g;-><init>(LH/f;Z)V

    sput-object v0, LH/h;->d:LH/g;

    return-void
.end method

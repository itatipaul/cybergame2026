.class public final Lp0/e;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final e:LD0/a;


# instance fields
.field public final a:LD0/c;

.field public final b:LD0/c;

.field public final c:LD0/c;

.field public final d:LD0/c;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, LD0/a;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, LD0/a;-><init>(F)V

    sput-object v0, Lp0/e;->e:LD0/a;

    return-void
.end method

.method public constructor <init>(LD0/c;LD0/c;LD0/c;LD0/c;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lp0/e;->a:LD0/c;

    iput-object p3, p0, Lp0/e;->b:LD0/c;

    iput-object p4, p0, Lp0/e;->c:LD0/c;

    iput-object p2, p0, Lp0/e;->d:LD0/c;

    return-void
.end method

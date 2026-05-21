.class public final LV/c;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field public static final a:LV/c;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, LV/c;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, LV/c;->a:LV/c;

    return-void
.end method

using System.Runtime.InteropServices;
using System.Text;
using static System.Console;
using static Platform;

WriteLine("Hello from .NET!");

MainFromRoc(out var rocStr);

WriteLine(rocStr);

public static partial class Platform
{
    [LibraryImport("interop", EntryPoint = "roc__mainForHost_1_exposed_generic")]
    internal static partial void MainFromRoc(out RocStr rocStr);
}

public unsafe struct RocStr
{
    public byte* Bytes;
    public UIntPtr Len;
    public UIntPtr Capacity;
    
    public ReadOnlySpan<char> ToCharSpan() =>
        Encoding.UTF8.GetString(Bytes, (int)Len.ToUInt32());

    public override string ToString() 
        => ToCharSpan().ToString();
    
    public static implicit operator string(RocStr rocStr) 
        => rocStr.ToString();
}

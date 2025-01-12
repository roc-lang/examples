using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using static System.Console;
using static Platform;

NativeLibrary.SetDllImportResolver(Assembly.GetExecutingAssembly(), CustomResolver);

WriteLine("Hello from .NET!");

MainFromRoc(out var rocStr);

WriteLine(rocStr);

//Load native library even when the name doesn't exactly match the name of the library defined in `LibraryImport`
//eg: `interop.so.1.0` instead of `interop.so`
static IntPtr CustomResolver(string libraryName, Assembly assembly, DllImportSearchPath? searchPath)
{
    var libFile = Directory
        .EnumerateFiles(Directory.GetCurrentDirectory())
        .FirstOrDefault(e => e.Contains(libraryName));

    if (libFile != null)
    {
        return NativeLibrary.Load(libFile, assembly, searchPath);
    }

    return IntPtr.Zero;
}

public static partial class Platform
{
    [LibraryImport("interop", EntryPoint = "roc__main_for_host_1_exposed_generic")]
    internal static partial void MainFromRoc(out RocStr rocStr);
}

public unsafe struct RocStr
{
    public byte* Bytes;
    public UIntPtr Len;
    public UIntPtr Capacity;

    public override string ToString() => Encoding.UTF8.GetString(Bytes, (int)Len.ToUInt32());

    public static implicit operator string(RocStr rocStr) => rocStr.ToString();
}

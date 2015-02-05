using System;
using System.Runtime.InteropServices;

namespace MkLink 
{
    public class NativeMethods 
    {
        [DllImport("kernel32.dll", SetLastError = true, EntryPoint = "CreateSymbolicLink", CharSet = CharSet.Unicode)]
        [return: MarshalAs(UnmanagedType.I1)] 
        private static extern bool NativeCreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags);

        public static void CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags) 
        {
            if (!NativeCreateSymbolicLink(lpSymlinkFileName, lpTargetFileName, dwFlags)) 
                throw new System.ComponentModel.Win32Exception(); 
        }

        [DllImport("kernel32.dll", SetLastError = true, EntryPoint = "RemoveDirectory", CharSet = CharSet.Unicode)]
        private static extern bool NativeRemoveDirectory(string lpPathName);

        public static void RemoveDirectory(string lpPathName) 
        {
            if (!NativeRemoveDirectory(lpPathName))
                throw new System.ComponentModel.Win32Exception(); 
        }

        [DllImport("kernel32.dll", SetLastError = true, EntryPoint = "DeleteFile", CharSet = CharSet.Unicode)]
        private static extern bool NativeDeleteFile(string lpFileName);

        public static void DeleteFile(string lpFileName) 
        {
            if (!NativeDeleteFile(lpFileName))
                throw new System.ComponentModel.Win32Exception(); 
        }
    }
}
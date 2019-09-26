//
//  FileManagerUtil.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/25.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation

struct FileManagerUtil {
    //获取Document路径 并将通过iCloud自动备份
    public static func getDocumentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? "";
    }
    //获取Library路径
    public static func getLibraryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? "";
    }
    ////获取应用程序路径
    public static func getApplicationPath() -> String {
        return NSHomeDirectory();
    }
    
    ////获取Cache路径
    public static func getCachePath() -> String {
          return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? "";
    }
    //获取Temp路径
    public static func getTempPath() -> String {
        return NSTemporaryDirectory();
    }
    
    //判断文件是否存在于某个路径中
    public static func fileIsExistOfPath(filePath:String) -> Bool {
        var flag = false;
        let fileManager = FileManager.default;
        if fileManager.fileExists(atPath: filePath) {
            flag = true;
        }
        
        return flag;
    }
    //从某个路径中移除文件
    public static func removeFileOfPath(filePath:String) -> Bool {
        var flag = true;
        let fileManager = FileManager.default;
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath);
            }catch{
                flag = false;
            }
        }
        return flag;
    }
 /** 从URL路径中移除文件*/
    public static func removeFileOfPath(fileUrl:URL) -> Bool {
        var flag = true;
        let fileManager = FileManager.default;
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                try fileManager.removeItem(at: fileUrl);
            }catch{
                flag = false;
            }
        }
        return flag;
    }
    
     /** 创建文件路径*/
    public static func creatDirectoryWithPath(dirPath:String) ->Bool {
        var ret = true;
        let isExit = FileManager.default.fileExists(atPath: dirPath);
        if !isExit {
            do{
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil);
        
            }catch{
                ret = false;
            }
        }
        
        return ret;
    }
    
     /** 创建文件*/
    public static func creatFileWithPath(filePath:String) ->Bool {
        var ret = true;
        let isExit = FileManager.default.fileExists(atPath: filePath);
        if !isExit {
            do{
                let dirPath = URL.init(fileURLWithPath: filePath).deletingLastPathComponent().path;
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil);
                FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil);
            }catch{
                ret = false;
            }
        }
        
        return ret;
    }
    
    /** 保存文件*/
    
    public static func saveFile(filePath:String,data:Data) -> Bool{
        var ret = true;
        ret = creatFileWithPath(filePath: filePath);
        if (ret){
            do{
                try data.write(to: URL.init(fileURLWithPath: filePath), options: Data.WritingOptions.atomicWrite);
            }catch{
                ret = false;
            }
            
        }else{
            ret = false;
        }
        
        
        return ret;
    }
    
    /** 追加写文件*/
    
    public static func appendData(filePath:String,data:Data) -> Bool{
        var ret = true;
        ret = creatFileWithPath(filePath: filePath);
        if (ret){
            let handle  = FileHandle.init(forWritingAtPath: filePath)!;
            handle.seekToEndOfFile();
            handle.write(data);
            handle.synchronizeFile();
            handle.closeFile();
        }else{
            ret = false;
        }
        return ret;
    }
    /** 获取文件*/
    public static func getFileData(filePath:String) -> Data? {
        var ret = true;
        var data:Data?;
        ret = FileManager.default.fileExists(atPath: filePath);
        if (ret){
            let handle  = FileHandle.init(forReadingAtPath: filePath)!;
            data = handle.readDataToEndOfFile();
            handle.closeFile();
        }
        return data;
    }
    
      /** 读取文件指定内容*/
    
    public static func getFileData(filePath:String,startIndex:UInt64, length:Int) -> Data? {
        var data:Data?;
        let ret = FileManager.default.fileExists(atPath: filePath);
        if (ret){
            let handle  = FileHandle.init(forReadingAtPath: filePath)!;
            handle.seek(toFileOffset: startIndex);
            data = handle.readData(ofLength: length);
            handle.closeFile();
        }
        
        return data;
    }
    
     /** 移动文件*/
    
    public static func moveFileFrom(path:String,toPath:String) ->Bool {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            return false;
        }
        
        if !fileManger.fileExists(atPath: toPath){
            return false;
        }
        
        do{
            try fileManger.moveItem(atPath: path, toPath: toPath);
            return true;
        }catch{
            return false;
        }
     
    }
    
    
    /** 拷贝文件*/
    public static func copyFileFromPath(path:String,toPath:String) ->Bool {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            return false;
        }
        
        if !fileManger.fileExists(atPath: toPath){
            return false;
        }
        
        do{
            try fileManger.copyItem(atPath: path, toPath: toPath);
            return true;
        }catch{
            return false;
        }
        
    }
    
    /** 获取文件夹下文件列表*/
    public static func getFileListInFolderWithPath(path:String) ->[String]? {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            do{
                let fileList  = try fileManger.contentsOfDirectory(atPath: path);
                return fileList;
            }catch{
                return nil;
            }
            
        }
        
        return nil;
        
    }
    
    
    /** 获取文件大小*/
    public static func getFileSizeWithPath(path:String) ->String? {
        let fileManger = FileManager.default;
        var fileLength:UInt64 = 0;
        
        if !fileManger.fileExists(atPath: path){
            //var fileSize:UInt64?;
            var sizeString:String?;
            do{
                let fileAttributes  = try fileManger.attributesOfItem(atPath: path);
                fileLength = fileAttributes[FileAttributeKey.size] as! UInt64 ;
                if (fileLength < 1024) {
                    sizeString = String.init(format: "%.1lluB", fileLength) ;
                }else if (fileLength > 1024 && fileLength < 1024*1024){
                    sizeString = String.init(format: "%.1lluKB", fileLength/1024);
                }else if (fileLength > 1024*1024 && fileLength < 1024*1024*1024){
                    sizeString = String.init(format: "%.1lluMB", fileLength/(1024*1024));
                }
                return sizeString;
               
            }catch{
                return nil;
            }
            
        }
        
        return nil;
        
    }
    
     /** 获取文件创建时间*/
    public static func getFileCreatDateWithPath(path:String) ->String? {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            do{
                let fileAttributes  = try fileManger.attributesOfItem(atPath: path);
                let filedate  = fileAttributes[FileAttributeKey.creationDate] ;
                return (filedate as! String);
            }catch{
                return nil;
            }
            
        }
        
        return nil;
        
    }
    
    /** 获取文件所有者*/
    public static func getFileOwnerWithPath(path:String) ->String? {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            do{
                let fileAttributes  = try fileManger.attributesOfItem(atPath: path);
                let fileOwner  = fileAttributes[FileAttributeKey.ownerAccountName] ;
                return (fileOwner as! String);
            }catch{
                return nil;
            }
            
        }
        
        return nil;
        
    }
    
    /** 获取文件更改日期*/
    public static func getFileChangeDateWithPath(path:String) ->String? {
        let fileManger = FileManager.default;
        if !fileManger.fileExists(atPath: path){
            do{
                let fileAttributes  = try fileManger.attributesOfItem(atPath: path);
                let date  = fileAttributes[FileAttributeKey.modificationDate] ;
                return (date as! String);
            }catch{
                return nil;
            }
            
        }
        return nil;
    }
    
}

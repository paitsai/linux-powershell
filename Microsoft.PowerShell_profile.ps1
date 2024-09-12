Import-Module posh-git 
Import-Module oh-my-posh 
# Set-PoshPrompt -Theme Agnoster

# Set-PoshPrompt -Theme Honukai
oh-my-posh init pwsh --config "C:\Users\touka\AppData\Local\Programs\oh-my-posh\themes\amro.omp.json" | Invoke-Expression

function Touch {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        # 如果文件存在，更新文件的最后修改时间
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        # 如果文件不存在，创建新文件
        New-Item -Path $Path -ItemType File
    }
}

function rm {
    param (
        [string]$Path
    )
    Remove-Item -Path $Path -Force
}

function rm-rf {
    param (
        [string]$Path
    )
    Remove-Item -Path $Path -Recurse -Force
}

function cat {
    param (
        [string[]]$Paths
    )
    foreach ($Path in $Paths) {
        Get-Content -Path $Path
    }
}

function mkdir {
    param (
        [string]$Path
    )
    New-Item -Path $Path -ItemType Directory
}

function mv {
    param (
        [string]$Pattern,
        [string]$Destination
    )
    
    # 查找符合模式的文件和文件夹
    $items = Get-ChildItem -Path . -Recurse | Where-Object { $_.Name -match $Pattern }
    
    foreach ($item in $items) {
        $targetPath = Join-Path -Path $Destination -ChildPath $item.Name
        if ($item.PSIsContainer) {
            # 如果是文件夹，创建目标文件夹并递归移动内容
            New-Item -Path $targetPath -ItemType Directory -Force
            mv -Pattern ".*" -Destination $targetPath -Path $item.FullName
            Remove-Item -Path $item.FullName -Recurse -Force
        } else {
            Move-Item -Path $item.FullName -Destination $targetPath -Force
        }
    }
}

function cp {
    param (
        [string]$Pattern,
        [string]$Destination
    )
    
    # 查找符合模式的文件和文件夹
    $items = Get-ChildItem -Path . -Recurse | Where-Object { $_.Name -match $Pattern }
    
    foreach ($item in $items) {
        $targetPath = Join-Path -Path $Destination -ChildPath $item.Name
        if ($item.PSIsContainer) {
            # 如果是文件夹，创建目标文件夹并递归复制内容
            New-Item -Path $targetPath -ItemType Directory -Force
            cp -Pattern ".*" -Destination $targetPath -Path $item.FullName
        } else {
            Copy-Item -Path $item.FullName -Destination $targetPath -Force
        }
    }
}
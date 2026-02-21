Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Mini Win Tool v2"
$form.Size = New-Object System.Drawing.Size(450,350)
$form.StartPosition = "CenterScreen"

# LOG BOX
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.Size = New-Object System.Drawing.Size(400,100)
$logBox.Location = New-Object System.Drawing.Point(20,200)
$logBox.ScrollBars = "Vertical"

# TASKBAR BUTTON
$btnTaskbar = New-Object System.Windows.Forms.Button
$btnTaskbar.Text = "Taskbar Gizle / Göster"
$btnTaskbar.Size = New-Object System.Drawing.Size(180,40)
$btnTaskbar.Location = New-Object System.Drawing.Point(20,20)

$btnTaskbar.Add_Click({
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
    $key = Get-ItemProperty -Path $path
    $bytes = $key.Settings

    if ($bytes[8] -eq 3) {
        $bytes[8] = 2
        $logBox.AppendText("Taskbar Gösterildi`r`n")
    } else {
        $bytes[8] = 3
        $logBox.AppendText("Taskbar Gizlendi`r`n")
    }

    Set-ItemProperty -Path $path -Name Settings -Value $bytes
    Stop-Process -Name explorer -Force
})

# DARK MODE BUTTON
$btnDark = New-Object System.Windows.Forms.Button
$btnDark.Text = "Dark Mode Aç / Kapat"
$btnDark.Size = New-Object System.Drawing.Size(180,40)
$btnDark.Location = New-Object System.Drawing.Point(220,20)

$btnDark.Add_Click({
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $current = (Get-ItemProperty -Path $regPath).AppsUseLightTheme

    if ($current -eq 1) {
        Set-ItemProperty -Path $regPath -Name AppsUseLightTheme -Value 0
        $logBox.AppendText("Dark Mode Açıldı`r`n")
    } else {
        Set-ItemProperty -Path $regPath -Name AppsUseLightTheme -Value 1
        $logBox.AppendText("Light Mode Açıldı`r`n")
    }
})

# SYSTEM INFO BUTTON
$btnInfo = New-Object System.Windows.Forms.Button
$btnInfo.Text = "Sistem Bilgisi"
$btnInfo.Size = New-Object System.Drawing.Size(180,40)
$btnInfo.Location = New-Object System.Drawing.Point(20,80)

$btnInfo.Add_Click({
    $os = Get-CimInstance Win32_OperatingSystem
    $logBox.AppendText("OS: $($os.Caption)`r`n")
    $logBox.AppendText("RAM: $([math]::Round($os.TotalVisibleMemorySize/1MB,2)) GB`r`n")
})

# EXPLORER RESTART BUTTON
$btnExplorer = New-Object System.Windows.Forms.Button
$btnExplorer.Text = "Explorer Restart"
$btnExplorer.Size = New-Object System.Drawing.Size(180,40)
$btnExplorer.Location = New-Object System.Drawing.Point(220,80)

$btnExplorer.Add_Click({
    Stop-Process -Name explorer -Force
    $logBox.AppendText("Explorer Yeniden Başlatıldı`r`n")
})

$form.Controls.AddRange(@($btnTaskbar,$btnDark,$btnInfo,$btnExplorer,$logBox))
$form.Topmost = $true
[void] $form.ShowDialog()

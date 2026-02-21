Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Mini Win Tool"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

$button = New-Object System.Windows.Forms.Button
$button.Text = "Taskbar Gizle / Göster"
$button.Size = New-Object System.Drawing.Size(200,40)
$button.Location = New-Object System.Drawing.Point(100,60)

$button.Add_Click({

    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
    $key = Get-ItemProperty -Path $path
    $bytes = $key.Settings

    # 9. byte taskbar davranışı kontrol eder
    if ($bytes[8] -eq 3) {
        $bytes[8] = 2   # Göster
    } else {
        $bytes[8] = 3   # Gizle
    }

    Set-ItemProperty -Path $path -Name Settings -Value $bytes

    Stop-Process -Name explorer -Force
})

$form.Controls.Add($button)
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
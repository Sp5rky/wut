# $inputXML = Get-Content "MainWindow.xaml" #uncomment for development
$inputXML = (New-Object Net.WebClient).DownloadString("https://bit.ly/TFwutconfig")

Add-Type -AssemblyName PresentationFramework
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$msgBoxInput = [System.Windows.MessageBox]::Show("You must run this program as an administrator to make changes.","Confirm Read-Only","OKCancel","Error")
	switch ($msgBoxInput) {
		"OK" {
			## Continue
		}
		"Cancel" {
			exit 0
		}
	}
}

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*','<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try { $Form = [Windows.Markup.XamlReader]::Load($reader) }
catch [System.Management.Automation.MethodInvocationException]{
	Write-Warning "We ran into a problem with the XAML code.  Check the syntax for this control..."
	Write-Host $error[0].Exception.Message -ForegroundColor Red
	if ($error[0].Exception.Message -like "*button*") {
		Write-Warning "Ensure your &lt;button in the `$inputXML does NOT have a Click=ButtonClick property.  PS can't handle this`n`n`n`n"
	}
}
catch {
	# If it broke some other way <img draggable="false" role="img" class="emoji" alt="😀" src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/svg/1f600.svg">
	Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) }

function Get-FormVariables {
	#If ($global:ReadmeDisplay -ne $true) { Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow; $global:ReadmeDisplay = $true }


	Write-Host ""
	Write-Host "                   .-+++++++++++++++=.    "
	Write-Host "                  -##=-------------*##    "
	Write-Host "      ............--..............:##+    "
	Write-Host " .+###############################*=:     "
	Write-Host ".##.             ==                       "
	Write-Host ".##=============+##=========-:            "
	Write-Host " .=++++++++++++*##*++++++++*##:           "
	Write-Host "               :==         =##.           "
	Write-Host "          .+################+.            "
	Write-Host "         -#*::=+=:::::::::.               "
	Write-Host "         ##.  ##-                         "
	Write-Host "        +#*  :#*                          "
	Write-Host "       :##:  +#-                          "
	Write-Host "       +##  :##                           "
	Write-Host "       ##=  ##=                           "
	Write-Host "      :##=:+#*                            "
	Write-Host ""
	Write-Host "Twisted Fish - Windows Utility Tool"
	Write-Host "          --WUT--                    "


	#====DEBUG GUI Elements====

	#write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
	#get-variable WPF*
}

Get-FormVariables

#===========================================================================
# Global Variables
#===========================================================================
$AppTitle = "Twisted Fish - Windows Utility Tool"


#===========================================================================
# Navigation Controls
#===========================================================================

$WPFTab1BT.Add_Click({
		$WPFTabNav.Items[0].IsSelected = $true
		$WPFTabNav.Items[1].IsSelected = $false
		$WPFTabNav.Items[2].IsSelected = $false
	})
$WPFTab2BT.Add_Click({
		$WPFTabNav.Items[0].IsSelected = $false
		$WPFTabNav.Items[1].IsSelected = $true
		$WPFTabNav.Items[2].IsSelected = $false
	})
$WPFTab3BT.Add_Click({
		$WPFTabNav.Items[0].IsSelected = $false
		$WPFTabNav.Items[1].IsSelected = $false
		$WPFTabNav.Items[2].IsSelected = $true
	})


#===========================================================================
# Tab 1 - Install
#===========================================================================
$WPFinstall.Add_Click({
		$wingetinstall = New-Object System.Collections.Generic.List[System.Object]
		if ($WPFInstalllibreoffice.IsChecked -eq $true) {
			$wingetinstall.Add("TheDocumentFoundation.LibreOffice")
			$WPFInstalllibreoffice.IsChecked = $false
		}
		if ($WPFInstalladobe.IsChecked -eq $true) {
			$wingetinstall.Add("Adobe.Acrobat.Reader.64-bit")
			$WPFInstalladobe.IsChecked = $false
		}
		if ($WPFInstallkaseya.IsChecked -eq $true) {
			Invoke-WebRequest -outf kaseya.exe http://twistedfish.com/KcsSetup.exe
			Write-Host "Running Kaseya Agent"
			cmd /c kaseya.exe
			Write-Host "Installed Kaseya Agent"
			Remove-Item ".\kaseya.exe"
			$WPFInstallkaseya.IsChecked = $false
		}
		if ($WPFInstallo365.IsChecked -eq $true) {
			Invoke-WebRequest -outf "C:\temp\officesetup.exe" https://github.com/Sp5rky/wut/raw/main/OfficeSetup.exe
			Write-Host "Running Office 365 Setup"
			Start-Process "C:\temp\officesetup.exe"
			Write-Host "Installed Office 365"
			$WPFInstallo365.IsChecked = $false
		}
		if ($WPFInstalladvancedip.IsChecked -eq $true) {
			$wingetinstall.Add("Famatech.AdvancedIPScanner")
			$WPFInstalladvancedip.IsChecked = $false
		}
		if ($WPFInstall3cx.IsChecked -eq $true) {
			$wingetinstall.Add("3CX.Softphone")
			$WPFInstall3cx.IsChecked = $false
		}
		if ($WPFInstallnetextender.IsChecked -eq $true) {
			$wingetinstall.Add("SonicWALL.NetExtender")
			$WPFInstallnetextender.IsChecked = $false
		}
		if ($WPFInstallatom.IsChecked -eq $true) {
			$wingetinstall.Add("GitHub.Atom")
			$WPFInstallatom.IsChecked = $false
		}
		if ($WPFInstallaudacity.IsChecked -eq $true) {
			$wingetinstall.Add("Audacity.Audacity")
			$WPFInstallaudacity.IsChecked = $false
		}
		if ($WPFInstallautohotkey.IsChecked -eq $true) {
			$wingetinstall.Add("Lexikos.AutoHotkey")
			$WPFInstallautohotkey.IsChecked = $false
		}
		if ($WPFInstallbrave.IsChecked -eq $true) {
			$wingetinstall.Add("BraveSoftware.BraveBrowser")
			$WPFInstallbrave.IsChecked = $false
		}
		if ($WPFInstallchrome.IsChecked -eq $true) {
			$wingetinstall.Add("Google.Chrome")
			$WPFInstallchrome.IsChecked = $false
		}
		if ($WPFInstalltor.IsChecked -eq $true) {
			$wingetinstall.Add("TorProject.TorBrowser")
			$WPFInstalltor.IsChecked = $false
		}
		if ($WPFInstalldiscord.IsChecked -eq $true) {
			$wingetinstall.Add("Discord.Discord")
			$WPFInstalldiscord.IsChecked = $false
		}
		if ($WPFInstallesearch.IsChecked -eq $true) {
			$wingetinstall.Add("voidtools.Everything --source winget")
			$WPFInstallesearch.IsChecked = $false
		}
		if ($WPFInstalletcher.IsChecked -eq $true) {
			$wingetinstall.Add("Balena.Etcher")
			$WPFInstalletcher.IsChecked = $false
		}
		if ($WPFInstallfirefox.IsChecked -eq $true) {
			$wingetinstall.Add("Mozilla.Firefox")
			$WPFInstallfirefox.IsChecked = $false
		}
		if ($WPFInstallgimp.IsChecked -eq $true) {
			$wingetinstall.Add("GIMP.GIMP")
			$WPFInstallgimp.IsChecked = $false
		}
		if ($WPFInstallgit.IsChecked -eq $true) {
			$wingetinstall.Add("Git.Git")
			$WPFInstallgithubdesktop.IsChecked = $false
		}
		if ($WPFInstallawsvpn.IsChecked -eq $true) {
			$wingetinstall.Add("Amazon.AWSVPNClient")
			$WPFInstallawsvpn.IsChecked = $false
		}
		if ($WPFInstallwebex.IsChecked -eq $true) {
			$wingetinstall.Add("Cisco.CiscoWebexMeetings")
			$WPFInstallwebex.IsChecked = $false
		}
		if ($WPFInstallgithubdesktop.IsChecked -eq $true) {
			$wingetinstall.Add("GitHub.GitHubDesktop")
			$WPFInstallgithubdesktop.IsChecked = $false
		}
		if ($WPFInstallimageglass.IsChecked -eq $true) {
			$wingetinstall.Add("DuongDieuPhap.ImageGlass")
			$WPFInstallimageglass.IsChecked = $false
		}
		if ($WPFInstalljava8.IsChecked -eq $true) {
			$wingetinstall.Add("Oracle.JavaRuntimeEnvironment")
			$WPFInstalljava8.IsChecked = $false
		}
		if ($WPFInstalljetbrains.IsChecked -eq $true) {
			$wingetinstall.Add("JetBrains.Toolbox")
			$WPFInstalljetbrains.IsChecked = $false
		}
		if ($WPFInstallmpc.IsChecked -eq $true) {
			$wingetinstall.Add("clsid2.mpc-hc")
			$WPFInstallmpc.IsChecked = $false
		}
		if ($WPFInstallnodejs.IsChecked -eq $true) {
			$wingetinstall.Add("OpenJS.NodeJS")
			$WPFInstallnodejs.IsChecked = $false
		}
		if ($WPFInstallnodejslts.IsChecked -eq $true) {
			$wingetinstall.Add("OpenJS.NodeJS.LTS")
			$WPFInstallnodejslts.IsChecked = $false
		}
		if ($WPFInstallnotepadplus.IsChecked -eq $true) {
			$wingetinstall.Add("Notepad++.Notepad++")
			$WPFInstallnotepadplus.IsChecked = $false
		}
		if ($WPFInstallpowertoys.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.PowerToys")
			$WPFInstallpowertoys.IsChecked = $false
		}
		if ($WPFInstallputty.IsChecked -eq $true) {
			$wingetinstall.Add("PuTTY.PuTTY")
			$WPFInstallputty.IsChecked = $false
		}
		if ($WPFInstallpython3.IsChecked -eq $true) {
			$wingetinstall.Add("Python.Python.3")
			$WPFInstallpython3.IsChecked = $false
		}
		if ($WPFInstallrustlang.IsChecked -eq $true) {
			$wingetinstall.Add("Rustlang.Rust.MSVC")
			$WPFInstallrustlang.IsChecked = $false
		}
		if ($WPFInstallsevenzip.IsChecked -eq $true) {
			$wingetinstall.Add("7zip.7zip")
			$WPFInstallsevenzip.IsChecked = $false
		}
		if ($WPFInstallsharex.IsChecked -eq $true) {
			$wingetinstall.Add("ShareX.ShareX")
			$WPFInstallsharex.IsChecked = $false
		}
		if ($WPFInstallsublime.IsChecked -eq $true) {
			$wingetinstall.Add("SublimeHQ.SublimeText.4")
			$WPFInstallsublime.IsChecked = $false
		}
		if ($WPFInstallsumatra.IsChecked -eq $true) {
			$wingetinstall.Add("SumatraPDF.SumatraPDF")
			$WPFInstallsumatra.IsChecked = $false
		}
		if ($WPFInstallterminal.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.WindowsTerminal")
			$WPFInstallterminal.IsChecked = $false
		}
		if ($WPFInstallidm.IsChecked -eq $true) {
			$wingetinstall.Add("Tonec.InternetDownloadManager")
			$WPFInstallidm.IsChecked = $false
		}
		if ($WPFInstallalacritty.IsChecked -eq $true) {
			$wingetinstall.Add("Alacritty.Alacritty")
			$WPFInstallalacritty.IsChecked = $false
		}
		if ($WPFInstallttaskbar.IsChecked -eq $true) {
			$wingetinstall.Add("9PF4KZ2VN4W9")
			$WPFInstallttaskbar.IsChecked = $false
		}
		if ($WPFInstallvlc.IsChecked -eq $true) {
			$wingetinstall.Add("VideoLAN.VLC")
			$WPFInstallvlc.IsChecked = $false
		}
		if ($WPFInstallkdenlive.IsChecked -eq $true) {
			$wingetinstall.Add("KDE.Kdenlive")
			$WPFInstallkdenlive.IsChecked = $false
		}
		if ($WPFInstallvscode.IsChecked -eq $true) {
			$wingetinstall.Add("Git.Git")
			$wingetinstall.Add("Microsoft.VisualStudioCode --source winget")
			$WPFInstallvscode.IsChecked = $false
		}
		if ($WPFInstallvscodium.IsChecked -eq $true) {
			$wingetinstall.Add("Git.Git")
			$wingetinstall.Add("VSCodium.VSCodium")
			$WPFInstallvscodium.IsChecked = $false
		}
		if ($WPFInstallwinscp.IsChecked -eq $true) {
			$wingetinstall.Add("WinSCP.WinSCP")
			$WPFInstallputty.IsChecked = $false
		}
		if ($WPFInstallanydesk.IsChecked -eq $true) {
			$wingetinstall.Add("AnyDeskSoftwareGmbH.AnyDesk")
			$WPFInstallanydesk.IsChecked = $false
		}
		if ($WPFInstallbitwarden.IsChecked -eq $true) {
			$wingetinstall.Add("Bitwarden.Bitwarden")
			$WPFInstallbitwarden.IsChecked = $false
		}
		if ($WPFInstallblender.IsChecked -eq $true) {
			$wingetinstall.Add("BlenderFoundation.Blender")
			$WPFInstallblender.IsChecked = $false
		}
		if ($WPFInstallchromium.IsChecked -eq $true) {
			$wingetinstall.Add("eloston.ungoogled-chromium")
			$WPFInstallchromium.IsChecked = $false
		}
		if ($WPFInstallcpuz.IsChecked -eq $true) {
			$wingetinstall.Add("CPUID.CPU-Z")
			$WPFInstallcpuz.IsChecked = $false
		}
		if ($WPFInstalleartrumpet.IsChecked -eq $true) {
			$wingetinstall.Add("File-New-Project.EarTrumpet")
			$WPFInstalleartrumpet.IsChecked = $false
		}
		if ($WPFInstallepicgames.IsChecked -eq $true) {
			$wingetinstall.Add("EpicGames.EpicGamesLauncher")
			$WPFInstallepicgames.IsChecked = $false
		}
		if ($WPFInstallflameshot.IsChecked -eq $true) {
			$wingetinstall.Add("Flameshot.Flameshot")
			$WPFInstallflameshot.IsChecked = $false
		}
		if ($WPFInstallfoobar.IsChecked -eq $true) {
			$wingetinstall.Add("PeterPawlowski.foobar2000")
			$WPFInstallfoobar.IsChecked = $false
		}
		if ($WPFInstallgog.IsChecked -eq $true) {
			$wingetinstall.Add("GOG.Galaxy")
			$WPFInstallgog.IsChecked = $false
		}
		if ($WPFInstallgpuz.IsChecked -eq $true) {
			$wingetinstall.Add("TechPowerUp.GPU-Z")
			$WPFInstallgpuz.IsChecked = $false
		}
		if ($WPFInstallglaryutilities.IsChecked -eq $true) {
			$wingetinstall.Add("Glarysoft.GlaryUtilities")
			$WPFInstallglaryutilities.IsChecked = $false
		}
		if ($WPFInstallgreenshot.IsChecked -eq $true) {
			$wingetinstall.Add("Greenshot.Greenshot")
			$WPFInstallgreenshot.IsChecked = $false
		}
		if ($WPFInstallhandbrake.IsChecked -eq $true) {
			$wingetinstall.Add("HandBrake.HandBrake")
			$WPFInstallhandbrake.IsChecked = $false
		}
		if ($WPFInstallhexchat.IsChecked -eq $true) {
			$wingetinstall.Add("HexChat.HexChat")
			$WPFInstallhexchat.IsChecked = $false
		}
		if ($WPFInstallhwinfo.IsChecked -eq $true) {
			$wingetinstall.Add("REALiX.HWiNFO")
			$WPFInstallhwinfo.IsChecked = $false
		}
		if ($WPFInstallinkscape.IsChecked -eq $true) {
			$wingetinstall.Add("Inkscape.Inkscape")
			$WPFInstallinkscape.IsChecked = $false
		}
		if ($WPFInstallkeepass.IsChecked -eq $true) {
			$wingetinstall.Add("KeePassXCTeam.KeePassXC")
			$WPFInstallkeepass.IsChecked = $false
		}
		if ($WPFInstalllibrewolf.IsChecked -eq $true) {
			$wingetinstall.Add("LibreWolf.LibreWolf")
			$WPFInstalllibrewolf.IsChecked = $false
		}
		if ($WPFInstallmalwarebytes.IsChecked -eq $true) {
			$wingetinstall.Add("Malwarebytes.Malwarebytes")
			$WPFInstallmalwarebytes.IsChecked = $false
		}
		if ($WPFInstallmatrix.IsChecked -eq $true) {
			$wingetinstall.Add("Element.Element")
			$WPFInstallmatrix.IsChecked = $false
		}
		if ($WPFInstallmremoteng.IsChecked -eq $true) {
			$wingetinstall.Add("mRemoteNG.mRemoteNG")
			$WPFInstallmremoteng.IsChecked = $false
		}
		if ($WPFInstallnvclean.IsChecked -eq $true) {
			$wingetinstall.Add("TechPowerUp.NVCleanstall")
			$WPFInstallnvclean.IsChecked = $false
		}
		if ($WPFInstallobs.IsChecked -eq $true) {
			$wingetinstall.Add("OBSProject.OBSStudio")
			$WPFInstallobs.IsChecked = $false
		}
		if ($WPFInstallobsidian.IsChecked -eq $true) {
			$wingetinstall.Add("Obsidian.Obsidian")
			$WPFInstallobsidian.IsChecked = $false
		}
		if ($WPFInstallrevo.IsChecked -eq $true) {
			$wingetinstall.Add("RevoUninstaller.RevoUninstaller")
			$WPFInstallrevo.IsChecked = $false
		}
		if ($WPFInstallrufus.IsChecked -eq $true) {
			$wingetinstall.Add("Rufus.Rufus")
			$WPFInstallrufus.IsChecked = $false
		}
		if ($WPFInstallsignal.IsChecked -eq $true) {
			$wingetinstall.Add("OpenWhisperSystems.Signal")
			$WPFInstallsignal.IsChecked = $false
		}
		if ($WPFInstallskype.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.Skype")
			$WPFInstallskype.IsChecked = $false
		}
		if ($WPFInstallslack.IsChecked -eq $true) {
			$wingetinstall.Add("SlackTechnologies.Slack")
			$WPFInstallslack.IsChecked = $false
		}
		if ($WPFInstallspotify.IsChecked -eq $true) {
			$wingetinstall.Add("Spotify.Spotify")
			$WPFInstallspotify.IsChecked = $false
		}
		if ($WPFInstallsteam.IsChecked -eq $true) {
			$wingetinstall.Add("Valve.Steam")
			$WPFInstallsteam.IsChecked = $false
		}
		if ($WPFInstallteamviewer.IsChecked -eq $true) {
			$wingetinstall.Add("TeamViewer.TeamViewer")
			$WPFInstallteamviewer.IsChecked = $false
		}
		if ($WPFInstallbluejeans.IsChecked -eq $true) {
			$wingetinstall.Add("BlueJeans.BlueJeans")
			$WPFInstallbluejeans.IsChecked = $false
		}
		if ($WPFInstallteams.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.Teams")
			$WPFInstallteams.IsChecked = $false
		}
		if ($WPFInstalltreesize.IsChecked -eq $true) {
			$wingetinstall.Add("JAMSoftware.TreeSize.Free")
			$WPFInstalltreesize.IsChecked = $false
		}
		if ($WPFInstallvisualstudio.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.VisualStudio.2022.Community")
			$WPFInstallvisualstudio.IsChecked = $false
		}
		if ($WPFInstallvivaldi.IsChecked -eq $true) {
			$wingetinstall.Add("VivaldiTechnologies.Vivaldi")
			$WPFInstallvivaldi.IsChecked = $false
		}
		if ($WPFInstallvoicemeeter.IsChecked -eq $true) {
			$wingetinstall.Add("VB-Audio.Voicemeeter")
			$WPFInstallvoicemeeter.IsChecked = $false
		}
		if ($WPFInstallwindirstat.IsChecked -eq $true) {
			$wingetinstall.Add("WinDirStat.WinDirStat")
			$WPFInstallwindirstat.IsChecked = $false
		}
		if ($WPFInstallwiztree.IsChecked -eq $true) {
			$wingetinstall.Add("AntibodySoftware.WizTree")
			$WPFInstallwiztree.IsChecked = $false
		}
		if ($WPFInstallwireshark.IsChecked -eq $true) {
			$wingetinstall.Add("WiresharkFoundation.Wireshark")
			$WPFInstallwireshark.IsChecked = $false
		}
		if ($WPFInstallsimplewall.IsChecked -eq $true) {
			$wingetinstall.Add("Henry++.simplewall")
			$WPFInstallsimplewall.IsChecked = $false
		}
		if ($WPFInstallzoom.IsChecked -eq $true) {
			$wingetinstall.Add("Zoom.Zoom")
			$WPFInstallzoom.IsChecked = $false
		}
		if ($WPFInstallviber.IsChecked -eq $true) {
			$wingetinstall.Add("Viber.Viber")
			$WPFInstallviber.IsChecked = $false
		}
		if ($WPFInstalltwinkletray.IsChecked -eq $true) {
			$wingetinstall.Add("xanderfrangos.twinkletray")
			$WPFInstalltwinkletray.IsChecked = $false
		}
		if ($WPFInstallshell.IsChecked -eq $true) {
			$wingetinstall.Add("Nilesoft.Shell")
			$WPFInstallshell.IsChecked = $false
		}
		if ($WPFInstallklite.IsChecked -eq $true) {
			$wingetinstall.Add("CodecGuide.K-LiteCodecPack.Standard")
			$WPFInstallklite.IsChecked = $false
		}
		if ($WPFInstallsandboxie.IsChecked -eq $true) {
			$wingetinstall.Add("Sandboxie.Plus")
			$WPFInstallsandboxie.IsChecked = $false
		}
		if ($WPFInstallprocesslasso.IsChecked -eq $true) {
			$wingetinstall.Add("BitSum.ProcessLasso")
			$WPFInstallprocesslasso.IsChecked = $false
		}
		if ($WPFInstallwinmerge.IsChecked -eq $true) {
			$wingetinstall.Add("WinMerge.WinMerge")
			$WPFInstallwinmerge.IsChecked = $false
		}
		if ($WPFInstalldotnet3.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.DotNet.DesktopRuntime.3_1")
			$WPFInstalldotnet3.IsChecked = $false
		}
		if ($WPFInstalldotnet5.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.DotNet.DesktopRuntime.5")
			$WPFInstalldotnet5.IsChecked = $false
		}
		if ($WPFInstalldotnet6.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.DotNet.DesktopRuntime.6")
			$WPFInstalldotnet6.IsChecked = $false
		}
		if ($WPFInstallvc2015_64.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.VC++2015-2022Redist-x64")
			$WPFInstallvc2015_64.IsChecked = $false
		}
		if ($WPFInstallvc2015_32.IsChecked -eq $true) {
			$wingetinstall.Add("Microsoft.VC++2015-2022Redist-x86")
			$WPFInstallvc2015_32.IsChecked = $false
		}
		if ($WPFInstallfoxpdf.IsChecked -eq $true) {
			$wingetinstall.Add("Foxit.PhantomPDF")
			$WPFInstallfoxpdf.IsChecked = $false
		}
		if ($WPFInstallonlyoffice.IsChecked -eq $true) {
			$wingetinstall.Add("ONLYOFFICE.DesktopEditors")
			$WPFInstallonlyoffice.IsChecked = $false
		}
		if ($WPFInstallflux.IsChecked -eq $true) {
			$wingetinstall.Add("flux.flux")
			$WPFInstallflux.IsChecked = $false
		}
		if ($WPFInstallitunes.IsChecked -eq $true) {
			$wingetinstall.Add("Apple.iTunes")
			$WPFInstallitunes.IsChecked = $false
		}
		if ($WPFInstallcider.IsChecked -eq $true) {
			$wingetinstall.Add("CiderCollective.Cider")
			$WPFInstallcider.IsChecked = $false
		}
		if ($WPFInstalljoplin.IsChecked -eq $true) {
			$wingetinstall.Add("Joplin.Joplin")
			$WPFInstalljoplin.IsChecked = $false
		}
		if ($WPFInstallopenoffice.IsChecked -eq $true) {
			$wingetinstall.Add("Apache.OpenOffice")
			$WPFInstallopenoffice.IsChecked = $false
		}
		if ($WPFInstallruskdesk.IsChecked -eq $true) {
			$wingetinstall.Add("RustDesk.RustDesk")
			$WPFInstallruskdesk.IsChecked = $false
		}
		if ($WPFInstalljami.IsChecked -eq $true) {
			$wingetinstall.Add("SFLinux.Jami")
			$WPFInstalljami.IsChecked = $false
		}
		if ($WPFInstalljdownloader.IsChecked -eq $true) {
			$wingetinstall.Add("AppWork.JDownloader")
			$WPFInstalljdownloader.IsChecked = $false
		}
		if ($WPFInstallbluestacks.IsChecked -eq $true) {
			$wingetinstall.Add("BlueStack.BlueStacks")
			$WPFInstallbluestacks.IsChecked = $false
		}

		# Check if winget is installed
		Write-Host "Checking if Winget is Installed..."
		if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
			#Checks if winget executable exists and if the Windows Version is 1809 or higher
			Write-Host "Winget Already Installed"
		}
		else {
			if (((Get-ComputerInfo).WindowsVersion) -lt "1809") {
				#Checks if Windows Version is too old for winget
				Write-Host "Winget is not supported on this version of Windows (Pre-1809)"
			}
			else {
				function getNewestLink ($match) {
					$uri = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
					Write-Verbose "[$((Get-Date).TimeofDay)] Getting information from $uri"
					$get = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction stop
					Write-Verbose "[$((Get-Date).TimeofDay)] getting latest release"
					$data = $get[0].assets | Where-Object name -Match $match
					return $data.browser_download_url
				}

				$wingetUrl = getNewestLink ("msixbundle")
				$wingetLicenseUrl = getNewestLink ("License1.xml")

				function section ($text) {
<#
                        .SYNOPSIS
                        Prints a section divider for easy reading of the output.
                 
                        .DESCRIPTION
                        Prints a section divider for easy reading of the output.
                    #>
					Write-Output "###################################"
					Write-Output "# $text"
					Write-Output "###################################"
				}

				# Add AppxPackage and silently continue on error
				function AAP ($pkg) {
<#
                        .SYNOPSIS
                        Adds an AppxPackage to the system.
                 
                        .DESCRIPTION
                        Adds an AppxPackage to the system.
                    #>
					Add-AppxPackage $pkg -ErrorAction SilentlyContinue
				}

				# Download XAML nupkg and extract appx file
				section ("Downloading Xaml nupkg file... (19000000ish bytes)")
				$url = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.1"
				$nupkgFolder = "Microsoft.UI.Xaml.2.7.1.nupkg"
				$zipFile = "Microsoft.UI.Xaml.2.7.1.nupkg.zip"
				Invoke-WebRequest -Uri $url -OutFile $zipFile
				section ("Extracting appx file from nupkg file...")
				Expand-Archive $zipFile

				# Determine architecture
				if ([Environment]::Is64BitOperatingSystem) {
					section ("64-bit OS detected")

					# Install x64 VCLibs
					section ("Downloading & installing x64 VCLibs... (21000000ish bytes)")
					AAP ("https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx")

					# Install x64 XAML
					section ("Installing x64 XAML...")
					AAP ("Microsoft.UI.Xaml.2.7.1.nupkg\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx")
				} else {
					section ("32-bit OS detected")

					# Install x86 VCLibs
					section ("Downloading & installing x86 VCLibs... (21000000ish bytes)")
					AAP ("https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx")

					# Install x86 XAML
					section ("Installing x86 XAML...")
					AAP ("Microsoft.UI.Xaml.2.7.1.nupkg\tools\AppX\x86\Release\Microsoft.UI.Xaml.2.7.appx")
				}

				# Finally, install winget
				section ("Downloading winget... (21000000ish bytes)")
				$wingetPath = "winget.msixbundle"
				Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetPath
				$wingetLicensePath = "license1.xml"
				Invoke-WebRequest -Uri $wingetLicenseUrl -OutFile $wingetLicensePath
				section ("Installing winget...")
				Add-AppxProvisionedPackage -Online -PackagePath $wingetPath -LicensePath $wingetLicensePath -ErrorAction SilentlyContinue

				# Adding WindowsApps directory to PATH variable for current user
				section ("Adding WindowsApps directory to PATH variable for current user...")
				$path = [Environment]::GetEnvironmentVariable("PATH","User")
				$path = $path + ";" + [IO.Path]::Combine([Environment]::GetEnvironmentVariable("LOCALAPPDATA"),"Microsoft","WindowsApps")
				[Environment]::SetEnvironmentVariable("PATH",$path,"User")

				# Cleanup
				section ("Cleaning up...")
				Remove-Item $zipFile
				Remove-Item $nupkgFolder -Recurse
				Remove-Item $wingetPath
				Remove-Item $wingetLicensePath

				# Finished
				section ("Installation complete!")
				section ("Please restart your computer to complete the installation.")
				Write-Host "Winget Installed"
			}
		}

		if ($wingetinstall.Count -eq 0) {
			$WarningMsg = "Please select the program(s) to install"
			[System.Windows.MessageBox]::Show($WarningMsg,$AppTitle,[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)
			return
		}

		# Install all winget programs in new window
		$wingetinstall.ToArray()
		# Define Output variable
		$wingetResult = New-Object System.Collections.Generic.List[System.Object]
		foreach ($node in $wingetinstall) {
			try {
				Start-Process powershell.exe -Verb RunAs -ArgumentList "-command winget install -e --accept-source-agreements --accept-package-agreements --silent $node | Out-Host" -WindowStyle Normal
				$wingetResult.Add("$node`n")
				Start-Sleep -s 3
				Wait-Process winget -Timeout 90 -ErrorAction SilentlyContinue
			}
			catch [System.InvalidOperationException]{
				Write-Warning "Allow Yes on User Access Control to Install"
			}
			catch {
				Write-Error $_.Exception
			}
		}
		$wingetResult.ToArray()
		$wingetResult | ForEach-Object { $_ } | Out-Host

		# Popup after finished
		$ButtonType = [System.Windows.MessageBoxButton]::OK
		if ($wingetResult -ne "") {
			$Messageboxbody = "Installed Programs `n$($wingetResult)"
		}
		else {
			$Messageboxbody = "No Program(s) are installed"
		}
		$MessageIcon = [System.Windows.MessageBoxImage]::Information

		[System.Windows.MessageBox]::Show($Messageboxbody,$AppTitle,$ButtonType,$MessageIcon)

		Write-Host "================================="
		Write-Host "---  Installs are Finished    ---"
		Write-Host "================================="

	})

$WPFInstallUpgrade.Add_Click({
		$isUpgradeSuccess = $false
		try {
			Start-Process powershell.exe -Verb RunAs -ArgumentList "-command winget upgrade --all  | Out-Host" -Wait -WindowStyle Normal
			$isUpgradeSuccess = $true
		}
		catch [System.InvalidOperationException]{
			Write-Warning "Allow Yes on User Access Control to Upgrade"
		}
		catch {
			Write-Error $_.Exception
		}
		$ButtonType = [System.Windows.MessageBoxButton]::OK
		$Messageboxbody = if ($isUpgradeSuccess) { "Upgrade Done" } else { "Upgrade was not succesful" }
		$MessageIcon = [System.Windows.MessageBoxImage]::Information

		[System.Windows.MessageBox]::Show($Messageboxbody,$AppTitle,$ButtonType,$MessageIcon)
	})

#===========================================================================
# Tab 2 - Tweak Buttons
#===========================================================================
$WPFdesktop.Add_Click({

		$WPFEssTweaksAH.IsChecked = $false
		$WPFEssTweaksDeleteTempFiles.IsChecked = $true
		$WPFEssTweaksDeBloat.IsChecked = $true
		$WPFEssTweaksRemoveCortana.IsChecked = $false
		$WPFEssTweaksDiskCleanup.IsChecked = $true
		$WPFEssTweaksDVR.IsChecked = $false
		$WPFEssTweaksHiber.IsChecked = $false
		$WPFEssTweaksHome.IsChecked = $false
		$WPFEssTweaksLoc.IsChecked = $false
		$WPFEssTweaksRP.IsChecked = $false
		$WPFEssTweaksServices.IsChecked = $false
		$WPFEssTweaksStorage.IsChecked = $false
		$WPFEssTweaksTele.IsChecked = $false
		$WPFEssTweaksWifi.IsChecked = $false
		$WPFMiscTweaksDisableUAC.IsChecked = $false
		$WPFMiscTweaksDisableNotifications.IsChecked = $false
		$WPFMiscTweaksRightClickMenu.IsChecked = $false
		$WPFMiscTweaksPower.IsChecked = $false
		$WPFMiscTweaksNum.IsChecked = $false
		$WPFMiscTweaksLapPower.IsChecked = $false
		$WPFMiscTweaksLapNum.IsChecked = $false
	})

$WPFnone.Add_Click({

		$WPFEssTweaksAH.IsChecked = $false
		$WPFEssTweaksDeleteTempFiles.IsChecked = $false
		$WPFEssTweaksDeBloat.IsChecked = $false
		$WPFEssTweaksRemoveCortana.IsChecked = $false
		$WPFEssTweaksDiskCleanup.IsChecked = $false
		$WPFEssTweaksDVR.IsChecked = $false
		$WPFEssTweaksHiber.IsChecked = $false
		$WPFEssTweaksHome.IsChecked = $false
		$WPFEssTweaksLoc.IsChecked = $false
		$WPFEssTweaksRP.IsChecked = $false
		$WPFEssTweaksServices.IsChecked = $false
		$WPFEssTweaksStorage.IsChecked = $false
		$WPFEssTweaksTele.IsChecked = $false
		$WPFEssTweaksWifi.IsChecked = $false
		$WPFMiscTweaksDisableUAC.IsChecked = $false
		$WPFMiscTweaksDisableNotifications.IsChecked = $false
		$WPFMiscTweaksRightClickMenu.IsChecked = $false
		$WPFMiscTweaksPower.IsChecked = $false
		$WPFMiscTweaksNum.IsChecked = $false
		$WPFMiscTweaksLapPower.IsChecked = $false
		$WPFMiscTweaksLapNum.IsChecked = $false
	})

$WPFtweaksbutton.Add_Click({

		if ($WPFEssTweaksDVR.IsChecked -eq $true) {
			#Installing PowerRun to edit some restricted registry keys (Need this to disable Gamebar Presence Writer)
			curl.exe -s "https://www.sordum.org/files/download/power-run/PowerRun.zip" -o ".\PowerRun.zip"
			Expand-Archive -Path ".\PowerRun.zip" -DestinationPath ".\" -Force
			Copy-Item -Path ".\PowerRun\PowerRun.exe" -Destination "$env:windir" -Force
			Remove-Item -Path ".\PowerRun\",".\PowerRun.zip" -Recurse
		}

		if ($WPFchangedns.text -eq 'Google') {
			Write-Host "Setting DNS to Google for all connections..."
			$DC = "8.8.8.8"
			$Internet = "8.8.4.4"
			$dns = "$DC","$Internet"
			$Interface = Get-WmiObject Win32_NetworkAdapterConfiguration
			$Interface.SetDNSServerSearchOrder($dns) | Out-Null
		}
		if ($WPFchangedns.text -eq 'CloudFlare') {
			Write-Host "Setting DNS to CloudFlare for all connections..."
			$DC = "1.1.1.1"
			$Internet = "1.0.0.1"
			$dns = "$DC","$Internet"
			$Interface = Get-WmiObject Win32_NetworkAdapterConfiguration
			$Interface.SetDNSServerSearchOrder($dns) | Out-Null
		}
		if ($WPFchangedns.text -eq 'Level3') {
			Write-Host "Setting DNS to Level3 for all connections..."
			$DC = "4.2.2.2"
			$Internet = "4.2.2.4"
			$dns = "$DC","$Internet"
			$Interface = Get-WmiObject Win32_NetworkAdapterConfiguration
			$Interface.SetDNSServerSearchOrder($dns) | Out-Null
		}
		if ($WPFchangedns.text -eq 'OpenDNS') {
			Write-Host "Setting DNS to OpenDNS for all connections..."
			$DC = "208.67.222.222"
			$Internet = "208.67.220.220"
			$dns = "$DC","$Internet"
			$Interface = Get-WmiObject Win32_NetworkAdapterConfiguration
			$Interface.SetDNSServerSearchOrder($dns) | Out-Null
		}

		if ($WPFEssTweaksAH.IsChecked -eq $true) {
			Write-Host "Disabling Activity History..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
			$WPFEssTweaksAH.IsChecked = $false
		}

		if ($WPFEssTweaksDeleteTempFiles.IsChecked -eq $true) {
			Write-Host "Delete Temp Files"
			Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse
			Get-ChildItem -Path $env:TEMP *.* -Recurse | Remove-Item -Force -Recurse
			$WPFEssTweaksDeleteTempFiles.IsChecked = $false
			Write-Host "================================="
			Write-Host "--- !!!!ERRORS ARE NORMAL!!!! ---"
			Write-Host "--- Cleaned following folders:---"
			Write-Host "--- C:\Windows\Temp           ---"
			Write-Host "---" $env:TEMP"---"
			Write-Host "================================="
		}

		if ($WPFEssTweaksDVR.IsChecked -eq $true) {
			if (!(Test-Path "HKCU:\System\GameConfigStore")) {
				New-Item -Path "HKCU:\System\GameConfigStore" -Force
			}
			Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Type DWord -Value 1
			Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_HonorUserFSEBehaviorMode" -Type DWord -Value 1
			Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_EFSEFeatureFlags" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Type DWord -Value 2
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0

			#Disabling Gamebar Presence Writer, which causes stutter in games
			PowerRun.exe /SW:0 Powershell.exe -Command { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" -Name "ActivationType" -Type DWord -Value 0 }

			$WPFEssTweaksDVR.IsChecked = $false
		}
		if ($WPFEssTweaksHiber.IsChecked -eq $true) {
			Write-Host "Disabling Hibernation..."
			Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Type Dword -Value 0
			if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
			$WPFEssTweaksHiber.IsChecked = $false
		}
		if ($WPFEssTweaksHome.IsChecked -eq $true) {
			$WPFEssTweaksHome.IsChecked = $false
		}
		if ($WPFEssTweaksLoc.IsChecked -eq $true) {
			Write-Host "Disabling Location Tracking..."
			if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
			Write-Host "Disabling automatic Maps updates..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
			$WPFEssTweaksLoc.IsChecked = $false
		}
		if ($WPFMiscTweaksDisableTPMCheck.IsChecked -eq $true) {
			Write-Host "Disabling TPM Check..."
			if (!(Test-Path "HKLM:\SYSTEM\Setup\MoSetup")) {
				New-Item -Path "HKLM:\SYSTEM\Setup\MoSetup" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\MoSetup" -Name "AllowUpgradesWithUnsupportedTPM" -Type DWord -Value 1
			$WPFMiscTweaksDisableTPMCheck.IsChecked = $false
		}
		if ($WPFEssTweaksDiskCleanup.IsChecked -eq $true) {
			Write-Host "Running Disk Cleanup on Drive C:..."
			cmd /c cleanmgr.exe /d C: /VERYLOWDISK
			$WPFEssTweaksDiskCleanup.IsChecked = $false
		}
		if ($WPFMiscTweaksDisableUAC.IsChecked -eq $true) {
			Write-Host "Disabling UAC..."
			# This below is the pussy mode which can break some apps. Please. Leave this on 1.
			# below i will show a way to do it without breaking some Apps that check UAC. U need to be admin tho.
			# Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Type DWord -Value 0
			Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Type DWord -Value 0 # Default is 5
			# This will set the GPO Entry in Security so that Admin users elevate without any prompt while normal users still elevate and u can even leave it ennabled.
			# It will just not bother u anymore
			$WPFMiscTweaksDisableUAC.IsChecked = $false
		}

		if ($WPFMiscTweaksDisableNotifications.IsChecked -eq $true) {
			Write-Host "Disabling Notifications and Action Center..."
			New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -Force
			New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -PropertyType "DWord" -Value 1
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType "DWord" -Value 0 -Force
			$WPFMiscTweaksDisableNotifications.IsChecked = $false
		}

		if ($WPFMiscTweaksRightClickMenu.IsChecked -eq $true) {
			Write-Host "Setting Classic Right-Click Menu..."
			New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -Force -Value ""
			$WPFMiscTweaksRightClickMenu.IsChecked = $false
		}
		if ($WPFEssTweaksRP.IsChecked -eq $true) {
			Write-Host "Creating Restore Point in case something bad happens"
			Enable-ComputerRestore -Drive "$env:SystemDrive"
			Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"
			$WPFEssTweaksRP.IsChecked = $false
		}
		if ($WPFEssTweaksServices.IsChecked -eq $true) {
			# Set Services to Manual 

			$services = @(
				"ALG" # Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
				"AJRouter" # Needed for AllJoyn Router Service
				"BcastDVRUserService_48486de" # GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
				#"BDESVC"                                      # Bitlocker Drive Encryption Service
				#"BFE"                                         # Base Filtering Engine (Manages Firewall and Internet Protocol security)
				#"BluetoothUserService_48486de"                # Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.
				#"BrokerInfrastructure"                        # Windows Infrastructure Service (Controls which background tasks can run on the system)
				"Browser" # Let users browse and locate shared resources in neighboring computers
				"BthAvctpSvc" # AVCTP service (needed for Bluetooth Audio Devices or Wireless Headphones)
				"CaptureService_48486de" # Optional screen capture functionality for applications that call the Windows.Graphics.Capture API.
				"cbdhsvc_48486de" # Clipboard Service
				"diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
				"DiagTrack" # Diagnostics Tracking Service
				"dmwappushservice" # WAP Push Message Routing Service
				"DPS" # Diagnostic Policy Service (Detects and Troubleshoots Potential Problems)
				"edgeupdate" # Edge Update Service
				"edgeupdatem" # Another Update Service
				#"EntAppSvc"                                    # Enterprise Application Management.
				"Fax" # Fax Service
				"fhsvc" # Fax History
				"FontCache" # Windows font cache
				#"FrameServer"                                 # Windows Camera Frame Server (Allows multiple clients to access video frames from camera devices)
				"gupdate" # Google Update
				"gupdatem" # Another Google Update Service
				#"iphlpsvc"                                     # ipv6(Most websites use ipv4 instead) - Needed for Xbox Live
				"lfsvc" # Geolocation Service
				#"LicenseManager"                              # Disable LicenseManager (Windows Store may not work properly)
				"lmhosts" # TCP/IP NetBIOS Helper
				"MapsBroker" # Downloaded Maps Manager
				"MicrosoftEdgeElevationService" # Another Edge Update Service
				"MSDTC" # Distributed Transaction Coordinator
				"NahimicService" # Nahimic Service
				#"ndu"                                          # Windows Network Data Usage Monitor (Disabling Breaks Task Manager Per-Process Network Monitoring)
				"NetTcpPortSharing" # Net.Tcp Port Sharing Service
				"PcaSvc" # Program Compatibility Assistant Service
				"PerfHost" # Remote users and 64-bit processes to query performance.
				"PhoneSvc" # Phone Service(Manages the telephony state on the device)
				#"PNRPsvc"                                     # Peer Name Resolution Protocol (Some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
				#"p2psvc"                                      # Peer Name Resolution Protocol(Enables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)iscord will still work)
				#"p2pimsvc"                                    # Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly. Discord will still work)
				"PrintNotify" # Windows printer notifications and extentions
				"QWAVE" # Quality Windows Audio Video Experience (audio and video might sound worse)
				"RemoteAccess" # Routing and Remote Access
				"RemoteRegistry" # Remote Registry
				"RetailDemo" # Demo Mode for Store Display
				"RtkBtManServ" # Realtek Bluetooth Device Manager Service
				"SCardSvr" # Windows Smart Card Service
				"seclogon" # Secondary Logon (Disables other credentials only password will work)
				"SEMgrSvc" # Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
				"SharedAccess" # Internet Connection Sharing (ICS)
				#"Spooler"                                     # Printing
				"stisvc" # Windows Image Acquisition (WIA)
				#"StorSvc"                                     # StorSvc (usb external hard drive will not be reconized by windows)
				"SysMain" # Analyses System Usage and Improves Performance
				"TrkWks" # Distributed Link Tracking Client
				#"WbioSrvc"                                    # Windows Biometric Service (required for Fingerprint reader / facial detection)
				"WerSvc" # Windows error reporting
				"wisvc" # Windows Insider program(Windows Insider will not work if Disabled)
				#"WlanSvc"                                     # WLAN AutoConfig
				"WMPNetworkSvc" # Windows Media Player Network Sharing Service
				"WpcMonSvc" # Parental Controls
				"WPDBusEnum" # Portable Device Enumerator Service
				"WpnService" # WpnService (Push Notifications may not work)
				#"wscsvc"                                      # Windows Security Center Service
				"WSearch" # Windows Search
				"XblAuthManager" # Xbox Live Auth Manager (Disabling Breaks Xbox Live Games)
				"XblGameSave" # Xbox Live Game Save Service (Disabling Breaks Xbox Live Games)
				"XboxNetApiSvc" # Xbox Live Networking Service (Disabling Breaks Xbox Live Games)
				"XboxGipSvc" # Xbox Accessory Management Service
				# Hp services
				"HPAppHelperCap"
				"HPDiagsCap"
				"HPNetworkCap"
				"HPSysInfoCap"
				"HpTouchpointAnalyticsService"
				# Hyper-V services
				"HvHost"
				"vmicguestinterface"
				"vmicheartbeat"
				"vmickvpexchange"
				"vmicrdv"
				"vmicshutdown"
				"vmictimesync"
				"vmicvmsession"
				# Services that cannot be disabled
				#"WdNisSvc"
			)

			foreach ($service in $services) {
				# -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist

				Write-Host "Setting $service StartupType to Manual"
				Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
			}
			$WPFEssTweaksServices.IsChecked = $false
		}
		if ($WPFEssTweaksStorage.IsChecked -eq $true) {
			Write-Host "Disabling Storage Sense..."
			Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue
			$WPFEssTweaksStorage.IsChecked = $false
		}
		if ($WPFEssTweaksTele.IsChecked -eq $true) {
			Write-Host "Disabling Telemetry..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
			Write-Host "Disabling Application suggestions..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
			if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
				New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
			Write-Host "Disabling Feedback..."
			if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
			Write-Host "Disabling Tailored Experiences..."
			if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
				New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
			Write-Host "Disabling Advertising ID..."
			if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
				New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
			Write-Host "Disabling Error reporting..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
			Write-Host "Restricting Windows Update P2P only to local network..."
			if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
			Write-Host "Stopping and disabling Diagnostics Tracking Service..."
			Stop-Service "DiagTrack" -WarningAction SilentlyContinue
			Set-Service "DiagTrack" -StartupType Disabled
			Write-Host "Stopping and disabling WAP Push Service..."
			Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
			Set-Service "dmwappushservice" -StartupType Disabled
			Write-Host "Enabling F8 boot menu options..."
			bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
			Write-Host "Disabling Remote Assistance..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
			Write-Host "Stopping and disabling Superfetch service..."
			Stop-Service "SysMain" -WarningAction SilentlyContinue
			Set-Service "SysMain" -StartupType Disabled

			# Task Manager Details
			if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
				Write-Host "Showing task manager details..."
				$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
				do {
					Start-Sleep -Milliseconds 100
					$preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
				} until ($preferences)
				Stop-Process $taskmgr
				$preferences.Preferences[28] = 0
				Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
			}
			else { Write-Host "Task Manager patch not run in builds 22557+ due to bug" }

			Write-Host "Showing file operations details..."
			if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
			}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1
			Write-Host "Hiding Task View button..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
			Write-Host "Hiding People icon..."
			if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
			}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

			Write-Host "Changing default Explorer view to This PC..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

			## Enable Long Paths
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Type DWORD -Value 1

			Write-Host "Hiding 3D Objects icon from This PC..."
			Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

			## Performance Tweaks and More Telemetry
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
			Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
			# Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10


			# Network Tweaks
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 4294967295

			# Gaming Tweaks
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

			# Group svchost.exe processes
			$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

			Write-Host "Disable News and Interests"
			if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds")) {
				New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
			# Remove "News and Interest" from taskbar
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

			# remove "Meet Now" button from taskbar

			if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
				New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
			}

			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

			Write-Host "Removing AutoLogger file and restricting directory..."
			$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
			if (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
				Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
			}
			icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

			Write-Host "Stopping and disabling Diagnostics Tracking Service..."
			Stop-Service "DiagTrack"
			Set-Service "DiagTrack" -StartupType Disabled
			Write-Host "Doing Security checks for Administrator Account and Group Policy"
			if (($(Get-WmiObject -Class Win32_ComputerSystem | Select-Object username).username).IndexOf('Administrator') -eq -1) {
				net user administrator /active:no
			}

			$WPFEssTweaksTele.IsChecked = $false
		}
		if ($WPFEssTweaksWifi.IsChecked -eq $true) {
			Write-Host "Disabling Wi-Fi Sense..."
			if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
			if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
			}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
			$WPFEssTweaksWifi.IsChecked = $false
		}
		if ($WPFMiscTweaksLapPower.IsChecked -eq $true) {
			if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") {
				Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 00000000
			}
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0000001
			$WPFMiscTweaksLapPower.IsChecked = $false
		}
		if ($WPFMiscTweaksLapNum.IsChecked -eq $true) {
			Write-Host "Disabling NumLock after startup..."
			if (!(Test-Path "HKU:")) {
				New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
			}
			Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 0
			$WPFMiscTweaksLapNum.IsChecked = $false
		}
		if ($WPFMiscTweaksPower.IsChecked -eq $true) {
			if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") {
				Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 00000001
			}
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0000000
			$WPFMiscTweaksPower.IsChecked = $false
		}
		if ($WPFMiscTweaksNum.IsChecked -eq $true) {
			Write-Host "Enabling NumLock after startup..."
			if (!(Test-Path "HKU:")) {
				New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
			}
			Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2
			$WPFMiscTweaksNum.IsChecked = $false
		}
		if ($WPFMiscTweaksExt.IsChecked -eq $true) {
			Write-Host "Showing known file extensions..."
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
			$WPFMiscTweaksExt.IsChecked = $false
		}
		if ($WPFMiscTweaksUTC.IsChecked -eq $true) {
			Write-Host "Setting BIOS time to UTC..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
			$WPFMiscTweaksUTC.IsChecked = $false
		}
		if ($WPFMiscTweaksDisplay.IsChecked -eq $true) {
			Write-Host "Adjusting visual effects for performance..."
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 200
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
			Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0
			Write-Host "Adjusted visual effects for performance"
			$WPFMiscTweaksDisplay.IsChecked = $false
		}
		if ($WPFEssTweaksRemoveCortana.IsChecked -eq $true) {
			Write-Host "Removing Cortana..."
			Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
			$WPFEssTweaksRemoveCortana.IsChecked = $false
		}
		if ($WPFEssTweaksDeBloat.IsChecked -eq $true) {
			$Bloatware = @(
				#Unnecessary Windows 10 AppX Apps
				"3DBuilder"
				"Microsoft3DViewer"
				"AppConnector"
				"BingFinance"
				"BingNews"
				"BingSports"
				"BingTranslator"
				"BingWeather"
				"BingFoodAndDrink"
				"BingHealthAndFitness"
				"BingTravel"
				"MinecraftUWP"
				"GamingServices"
				# "WindowsReadingList"
				"GetHelp"
				"Getstarted"
				"Messaging"
				"Microsoft3DViewer"
				"MicrosoftSolitaireCollection"
				"NetworkSpeedTest"
				"News"
				"Lens"
				"Sway"
				"OneNote"
				"OneConnect"
				"People"
				"Print3D"
				"SkypeApp"
				"Todos"
				"Wallet"
				"Whiteboard"
				"WindowsAlarms"
				"windowscommunicationsapps"
				"WindowsFeedbackHub"
				"WindowsMaps"
				"WindowsPhone"
				"WindowsSoundRecorder"
				"XboxApp"
				"ConnectivityStore"
				"CommsPhone"
				"ScreenSketch"
				"TCUI"
				"XboxGameOverlay"
				"XboxGameCallableUI"
				"XboxSpeechToTextOverlay"
				"MixedReality.Portal"
				"ZuneMusic"
				"ZuneVideo"
				#"YourPhone"
				"Getstarted"
				"MicrosoftOfficeHub"

				#Sponsored Windows 10 AppX Apps
				#Add sponsored/featured apps to remove in the "*AppName*" format
				"EclipseManager"
				"ActiproSoftwareLLC"
				"AdobeSystemsIncorporated.AdobePhotoshopExpress"
				"Duolingo-LearnLanguagesforFree"
				"PandoraMediaInc"
				"CandyCrush"
				"Clipchamp - Video Editor"
				"Disney+"
				"Dropbox"
				"Evernote"
				"Hearts Deluxe"
				"Instagram"
				"Messenger"
				"Prime Video"
				"Simple Mahjong"
				"Simple Solitaire"
				"Simple Spider Solitaire"
				"Spades"
				"Spotify"
				"Tiktok"
				"Xbox"
				"BubbleWitch3Saga"
				"Wunderlist"
				"Flipboard"
				"Twitter"
				"Facebook"
				"Royal Revolt"
				"Sway"
				"Speed Test"
				"Dolby"
				"Viber"
				"ACGMediaPlayer"
				"Netflix"
				"OneCalendar"
				"LinkedInforWindows"
				"HiddenCityMysteryofShadows"
				"Hulu"
				"HiddenCity"
				"AdobePhotoshopExpress"
				"HotspotShieldFreeVPN"
				"Tile"

				#Optional: Typically not removed but you can if you need to
				"Advertising"
				#"MSPaint"
				#"MicrosoftStickyNotes"
				#"Windows.Photos"
				#"WindowsCalculator"
				#"WindowsStore"

				# HPBloatware Packages
				"HPJumpStarts"
				"HPPCHardwareDiagnosticsWindows"
				"HPPowerManager"
				"HPPrivacySettings"
				"HPSureShieldAI"
				"HPSystemInformation"
				"HPQuickDrop"
				"HPWorkWell"
				"myHP"
				"HPDesktopSupportUtilities"
				"HPQuickTouch"
				"HPEasyClean"
				"HPSystemInformation"
				"HP Client Security Manager"
				"HP Connection Optimizer"
				"HP Documentation"
				"HP MAC Address Manager"
				"HP Notifications"
				"HP Security Update Service"
				"HP System Default Settings"
				"HP Sure Click"
				"HP Sure Click Security Browser"
				"HP Sure Run"
				"HP Sure Recover"
				"HP Sure Sense"
				"HP Sure Sense Installer"
				"HP Wolf Security"
				"HP Wolf Security Application Support for Sure Sense"
				"HP Wolf Security Application Support for Windows"
			)

			Write-Host "Removing Bloatware"

			foreach ($Bloat in $Bloatware) {
				Get-AppxPackage "*$Bloat*" | Remove-AppxPackage
				Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "*$Bloat*" | Remove-AppxProvisionedPackage -Online
				Write-Host "Trying to remove $Bloat."
			}

			$AdobeOffers = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Offers.lnk"
			if (Test-Path $AdobeOffers) {
				Remove-Item $AdobeOffers
				Write-Host "$AdobeOffers has been deleted"
			} else {
				Write-Host "$AdobeOffers doesn't exist"
			}

			$AdobeOffersFolder = "C:\Program Files (x86)\Online Services\Adobe"
			if (Test-Path $AdobeOffersFolder) {
				Remove-Item $AdobeOffersFolder -Force -Recurse
				Write-Host "$AdobeOffersFolder has been deleted"
			} else {
				Write-Host "$AdobeOffersFolder doesn't exist"
			}

			$AmazonStart1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Amazon.com.lnk"
			if (Test-Path $AmazonStart1) {
				Remove-Item $AmazonStart1
				Write-Host "$AmazonStart1 has been deleted"
			} else {
				Write-Host "$AmazonStart1 doesn't exist"
			}

			$HPDocumentation = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HP Documentation.lnk"
			if (Test-Path $HPDocumentation) {
				Remove-Item $HPDocumentation
				Write-Host "$HPDocumentation has been deleted"
			} else {
				Write-Host "$HPDocumentation doesn't exist"
			}

			$AgodaStart = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Agoda.lnk"
			if (Test-Path $AgodaStart) {
				Remove-Item $AgodaStart
				Write-Host "$AgodaStart has been deleted"
			} else {
				Write-Host "$AgodaStart doesn't exist"
			}

			$FOEStart = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Forge of Empires.lnk"
			if (Test-Path $FOEStart) {
				Remove-Item $FOEStart
				Write-Host "$FOEStart has been deleted"
			} else {
				Write-Host "$FOEStart doesn't exist"
			}

			$AppExplorerStart = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\App Explorer.lnk"
			if (Test-Path $AppExplorer) {
				Remove-Item $AppExplorer
				Write-Host "$AppExplorer has been deleted"
			} else {
				Write-Host "$AppExplorer doesn't exist"
			}

			$Planet9 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Planet9 Link.lnk"
			if (Test-Path $Planet9) {
				Remove-Item $Planet9
				Write-Host "$Planet9 has been deleted"
			} else {
				Write-Host "$Planet9 doesn't exist"
			}

			Write-Host "Finished Removing Bloatware Apps"
			Write-Host "Removing Bloatware Programs"
			# Remove installed programs
			$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }
			$InstalledPrograms | ForEach-Object {

				Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."

				try {
					$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
					Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
				}
				catch {
					Write-Warning -Message "Failed to uninstall: [$($_.Name)]"
				}
			}
			Write-Host "Finished Removing Bloatware Programs"
			$WPFEssTweaksDeBloat.IsChecked = $false
		}

		Write-Host "================================="
		Write-Host "--     Tweaks are Finished    ---"
		Write-Host "================================="

		$ButtonType = [System.Windows.MessageBoxButton]::OK
		$MessageboxTitle = "Tweaks are Finished "
		$Messageboxbody = ("Done")
		$MessageIcon = [System.Windows.MessageBoxImage]::Information

		[System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$MessageIcon)
	})

$WPFEnableDarkMode.Add_Click({
		Write-Host "Enabling Dark Mode"
		$Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
		Set-ItemProperty $Theme AppsUseLightTheme -Value 0
		Write-Host "Enabled"
	}
)

$WPFDisableDarkMode.Add_Click({
		Write-Host "Disabling Dark Mode"
		$Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
		Set-ItemProperty $Theme AppsUseLightTheme -Value 1
		Write-Host "Disabled"
	}
)
#===========================================================================
# Undo All
#===========================================================================
$WPFundoall.Add_Click({
		Write-Host "Creating Restore Point in case something bad happens"
		Enable-ComputerRestore -Drive "$env:SystemDrive"
		Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"

		Write-Host "Enabling Telemetry..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 1
		Write-Host "Enabling Wi-Fi Sense"
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 1
		Write-Host "Enabling Application suggestions..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
		if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent") {
			Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 0
		Write-Host "Enabling Activity History..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 1
		Write-Host "Enable Location Tracking..."
		if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location") {
			Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
		Write-Host "Enabling automatic Maps updates..."
		Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
		Write-Host "Enabling Feedback..."
		if (Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules") {
			Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 0
		Write-Host "Enabling Tailored Experiences..."
		if (Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent") {
			Remove-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 0
		Write-Host "Disabling Advertising ID..."
		if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo") {
			Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 0
		Write-Host "Allow Error reporting..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 0
		Write-Host "Allowing Diagnostics Tracking Service..."
		Stop-Service "DiagTrack" -WarningAction SilentlyContinue
		Set-Service "DiagTrack" -StartupType Manual
		Write-Host "Allowing WAP Push Service..."
		Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
		Set-Service "dmwappushservice" -StartupType Manual
		Write-Host "Allowing Home Groups services..."
		Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
		Set-Service "HomeGroupListener" -StartupType Manual
		Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
		Set-Service "HomeGroupProvider" -StartupType Manual
		Write-Host "Enabling Storage Sense..."
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" | Out-Null
		Write-Host "Allowing Superfetch service..."
		Stop-Service "SysMain" -WarningAction SilentlyContinue
		Set-Service "SysMain" -StartupType Manual
		Write-Host "Setting BIOS time to Local Time instead of UTC..."
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 0
		Write-Host "Enabling Hibernation..."
		Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 1
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue

		Write-Host "Hiding file operations details..."
		if (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager") {
			Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Recurse -ErrorAction SilentlyContinue
		}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 0
		Write-Host "Showing Task View button..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 1

		Write-Host "Changing default Explorer view to Quick Access..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

		Write-Host "Unrestricting AutoLogger directory"
		$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
		icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null

		Write-Host "Enabling and starting Diagnostics Tracking Service"
		Set-Service "DiagTrack" -StartupType Automatic
		Start-Service "DiagTrack"

		Write-Host "Hiding known file extensions"
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1

		Write-Host "Reset Local Group Policies to Stock Defaults"
		# cmd /c secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
		cmd /c Remove-Item /S /Q "%WinDir%\System32\GroupPolicyUsers"
		cmd /c Remove-Item /S /Q "%WinDir%\System32\GroupPolicy"
		cmd /c gpupdate /force
		# Considered using Invoke-GPUpdate but requires module most people won't have installed

		Write-Output "Adjusting visual effects for appearance..."
		Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 1
		Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 400
		Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](158,30,7,128,18,0,0,0))
		Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 1
		Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 1
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 1
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
		Write-Host "Restoring Clipboard History..."
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Clipboard" -Name "EnableClipboardHistory" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowClipboardHistory" -ErrorAction SilentlyContinue
		Write-Host "Enabling Notifications and Action Center"
		Remove-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled"
		Write-Host "Restoring Default Right Click Menu Layout"
		Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Confirm:$false -Force

		Write-Host "Reset News and Interests"
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 1
		# Remove "News and Interest" from taskbar
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 0
		Write-Host "Done - Reverted to Stock Settings"

		#Enable Gamebar Presence Writer
		PowerRun.exe /SW:0 Powershell.exe -Command { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" -Name "ActivationType" -Type DWord -Value 1 }

		Write-Host "Essential Undo Completed"

		$ButtonType = [System.Windows.MessageBoxButton]::OK
		$MessageboxTitle = "Undo All"
		$Messageboxbody = ("Done")
		$MessageIcon = [System.Windows.MessageBoxImage]::Information

		[System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$MessageIcon)

		Write-Host "================================="
		Write-Host "---   Undo All is Finished    ---"
		Write-Host "================================="
	})

#===========================================================================
# Tab 3 - Config Buttons
#===========================================================================
$WPFFeatureInstall.Add_Click({

		if ($WPFFeaturesdotnet.IsChecked -eq $true) {
			Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart
		}
		if ($WPFFeatureshyperv.IsChecked -eq $true) {
			Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-All" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Tools-All" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Management-PowerShell" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Hypervisor" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Services" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Management-Clients" -All -NoRestart
			cmd /c bcdedit /set hypervisorschedulertype classic
			Write-Host "HyperV is now installed and configured. Please Reboot before using."
		}
		if ($WPFFeatureslegacymedia.IsChecked -eq $true) {
			Enable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "MediaPlayback" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "DirectPlay" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "LegacyComponents" -All -NoRestart
		}
		if ($WPFFeaturewsl.IsChecked -eq $true) {
			Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart
			Write-Host "WSL is now installed and configured. Please Reboot before using."
		}
		if ($WPFFeaturenfs.IsChecked -eq $true) {
			Enable-WindowsOptionalFeature -Online -FeatureName "ServicesForNFS-ClientOnly" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "ClientForNFS-Infrastructure" -All -NoRestart
			Enable-WindowsOptionalFeature -Online -FeatureName "NFS-Administration" -All -NoRestart
			nfsadmin client stop
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default" -Name "AnonymousUID" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default" -Name "AnonymousGID" -Type DWord -Value 0
			nfsadmin client start
			nfsadmin client localhost config fileaccess=755 SecFlavors=+sys -krb5 -krb5i
			Write-Host "NFS is now setup for user based NFS mounts"
		}
		$ButtonType = [System.Windows.MessageBoxButton]::OK
		$MessageboxTitle = "All features are now installed "
		$Messageboxbody = ("Done")
		$MessageIcon = [System.Windows.MessageBoxImage]::Information

		[System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$MessageIcon)

		Write-Host "================================="
		Write-Host "---  Features are Installed   ---"
		Write-Host "================================="
	})

$WPFPanelDISM.Add_Click({
		Start-Process PowerShell -ArgumentList "Write-Host '(1/4) Chkdsk' -ForegroundColor Green; Chkdsk /scan; 
    Write-Host '`n(2/4) SFC - 1st scan' -ForegroundColor Green; sfc /scannow;
    Write-Host '`n(3/4) DISM' -ForegroundColor Green; DISM /Online /Cleanup-Image /Restorehealth; 
    Write-Host '`n(4/4) SFC - 2nd scan' -ForegroundColor Green; sfc /scannow; 
    Read-Host '`nPress Enter to Continue'" -Verb runas
	}) #
$WPFPanelcontrol.Add_Click({
		cmd /c control
	})
$WPFPanelnetwork.Add_Click({
		cmd /c ncpa.cpl
	})
$WPFPanelpower.Add_Click({
		cmd /c powercfg.cpl
	})
$WPFPanelsound.Add_Click({
		cmd /c mmsys.cpl
	})
$WPFPanelsystem.Add_Click({
		cmd /c sysdm.cpl
	})
$WPFPaneluser.Add_Click({
		cmd /c "control userpasswords2"
	})


#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | Out-Null

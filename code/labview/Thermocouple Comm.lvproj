<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="15008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Log Data.vi" Type="VI" URL="../Log Data.vi"/>
		<Item Name="Log Data_PID.vi" Type="VI" URL="../Log Data_PID.vi"/>
		<Item Name="Log Data_PWM.vi" Type="VI" URL="../Log Data_PWM.vi"/>
		<Item Name="Main_onoff.vi" Type="VI" URL="../Main_onoff.vi"/>
		<Item Name="Main_PIDTune.vi" Type="VI" URL="../Main_PIDTune.vi"/>
		<Item Name="Main_PWM.vi" Type="VI" URL="../Main_PWM.vi"/>
		<Item Name="Poll.vi" Type="VI" URL="../Poll.vi"/>
		<Item Name="Read TC.vi" Type="VI" URL="../Read TC.vi"/>
		<Item Name="Read TC_PID.vi" Type="VI" URL="../Read TC_PID.vi"/>
		<Item Name="Read TC_PWM.vi" Type="VI" URL="../Read TC_PWM.vi"/>
		<Item Name="Start Log.vi" Type="VI" URL="../Start Log.vi"/>
		<Item Name="Start Log_PID.vi" Type="VI" URL="../Start Log_PID.vi"/>
		<Item Name="Streaming.vi" Type="VI" URL="../Streaming.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Application Directory.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Application Directory.vi"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="VISA Configure Serial Port" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port"/>
				<Item Name="VISA Configure Serial Port (Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Instr).vi"/>
				<Item Name="VISA Configure Serial Port (Serial Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Serial Instr).vi"/>
			</Item>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>

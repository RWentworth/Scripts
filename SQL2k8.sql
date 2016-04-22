print 'SQL 2008 Scripts, Procedures for Completing Checklist...'

print ''
print 'Current Date Time.........: ' + convert(varchar(30), getdate(), 113)
print 'User......................: ' + USER_NAME()
print ''
print 'Server Name...............: ' + convert(varchar(30), @@SERVERNAME)   
print 'Instance Name.............: ' + convert(varchar(30), @@SERVICENAME)
print '    if it is MSSQLSERVER, then a Default Install was performed...'
go

declare @ProductVersion	varchar(30)
declare @ProductLevel	varchar(30)
declare @ProductEdition	varchar(30)

SELECT @ProductVersion = convert(varchar(30), SERVERPROPERTY('productversion')), @ProductLevel = convert(varchar(30), SERVERPROPERTY('productlevel')), @ProductEdition = convert(varchar(30), SERVERPROPERTY('edition'))
print ''
print 'Product Edition...........: ' + @ProductEdition
print 'Product Version...........: ' + @ProductVersion
print 'Product Level.............: ' + @ProductLevel
go

set nocount on

create table #tmp_name (
		[name]		sysname not null,
		[weak]		bit null,
		[null]		bit null,
		[same]		bit null,
		[reverse]	bit null,
		[onechar]	bit null )

-- get all logins that are NOT nt-logins (isntname = 0)
insert into #tmp_name (
		[name],
		[weak],
		[null],
		[same],
		[reverse],
		[onechar] )
select	[name],
	0,
	0,
	0,
	0,
	0
from	sys.syslogins
where	isntname = 0

declare @Num_NTAccts varchar(4)
declare @Num_NON_NTAccts varchar(4)

SELECT @Num_NTAccts = convert(varchar(4), count(*)) from sys.syslogins where isntname = 1
SELECT @Num_Non_NTAccts = convert(varchar(4), count(*)) from #tmp_name

print 'Number of NT Accounts...............: ' + @Num_NTAccts
print 'Number of Non NT Accounts...........: ' + @Num_NON_NTAccts
print ''

-- check if password is null
update	n
set		[weak] = 1,
		[null] = 1
from	#tmp_name n,
		sys.syslogins sl
where	n.[name] = sl.[name] and
		sl.[password] is null

-- check if name is same as login
update	n
set		[weak] = 1,
		[same] = 1
from	#tmp_name n,
		sys.syslogins sl
where	n.[name] = sl.[name] and
		pwdcompare(sl.[name], sl.[password]) = 1

-- check if password is reversed
update	n
set		[weak] = 1,
		[reverse] = 1
from	#tmp_name n,
		sys.syslogins sl
where	n.[name] = sl.[name] and
		pwdcompare(reverse(sl.[name]), sl.[password]) = 1

-- check if password is one char long
declare	@char	int,
	@name	sysname
select	@char = 0
declare	MyC cursor for
		select	[name]
		from	#tmp_name
		order by
			[name]
open MyC
fetch next from MyC into @name
while @@fetch_status >= 0
begin
	while	@char < 256
	begin
		if (select pwdcompare(char(@char), [password]) from sys.syslogins where name = @name) = 1
		begin
			update	#tmp_name
			set	[weak] = 1,
				[onechar] = 1
			where	[name] = @name
		end
		select	@char = @char + 1
	end
	select @char = 0
	fetch next from MyC into @name
end
close MyC
deallocate MyC

-- return the result
declare @Num_Weak_Accts		varchar(4)
declare @Account_Name		varchar(40)
declare	@Null_PassWord		varchar(1)
declare @Same_Password		varchar(1)
declare @Reverse_Password	varchar(1)
declare @OneChar_Password	varchar(1)
declare @tab			int

set @tab = 9

SELECT @Num_Weak_Accts = convert(varchar(4), count(*)) from #tmp_name where [weak] = 1
print 'Number of WEAK Non NT Accounts...........: ' + @Num_Weak_Accts

if @Num_Weak_Accts >= 1
  begin
    print 'List of WEAK Non NT Accounts:'
    print ''
    declare	MyC cursor for 
	select	[name],
		[null],
		[same],
		[reverse],
		[onechar]
	from	#tmp_name
 	where [weak] = 1
	order by [name]

    open MyC

    print 'Account Name' + char(@tab) + 'Null' + char(@tab) + 'Same' + char(@tab) + 'Reverse' + char(@tab) + 'OneChar'
    print '============' + char(@tab) + '====' + char(@tab) + '====' + char(@tab) + '=======' + char(@tab) + '======='

    fetch next from MyC into @Account_Name, @Null_Password, @Same_Password, @Reverse_Password, @OneChar_Password
    while @@fetch_status >= 0
      begin
	print @Account_Name + char(@tab) + @Null_Password + char(@tab) + @Same_Password + char(@tab) + @Reverse_Password + char(@tab) + @OneChar_Password
	fetch next from MyC into @Account_Name, @Null_Password, @Same_Password, @Reverse_Password, @OneChar_Password
      end

    close MyC
    deallocate Myc
  end

-- clean up
drop table #tmp_name
go

print ' '
print 'Run SQL Server Installation Center - Tools - Installed SQL Server features discovery report'
print ' - this will provide a report of products and features installed on the local server'

print ' '
print '23) List Databases on Server'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 13) as 'Database_Name'
from sys.databases;

print '47) Location of Data and Log Files'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(name, 1, 13) as Logical_Name,
	substring(type_desc, 1, 12) as Type,
	substring(state_desc, 1, 17) as State,
	physical_name as File_Location
from sys.database_files;

print '51) Determine if Named Instance'
print ' '
print 'Instance Name = ' + convert(varchar(30), @@SERVICENAME)
print '    if it is MSSQLSERVER, then a Default Install was performed...'
go

print ' '
print '54 & 55) Login Info - Windows, SQL'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 40) as Principal_Name,
	substring(type_desc, 1, 30) as Type,
	is_disabled as Is_Login_Disabled,
	substring(default_database_name, 1, 20) as Default_Database
from sys.server_principals
order by type_desc,
	name;

--print ' '
print ' -- SQL Login Account Information'
print ' '

select substring(name, 1, 40) as Principal_Name,
	substring(type_desc, 1, 15) as Type,
	is_disabled as Is_Login_Disabled,
	substring(default_database_name, 1, 20) as Default_Database,
	is_policy_checked as Is_Policy_Checked,
	is_expiration_checked as Is_Expiration_Checked
from sys.sql_logins
order by name;

print '58) Filestream setting.  If value is 2, then it is a Finding'
print '  Using - Master'
print ' 0 = Disabled, 1 = Transact-SQL access, 2 = Transact-SQL and Win32 Streaming access'
print ' '
use master;
select name,
	substring(convert(char, value_in_use), 1, 16) as Current_Setting
from sys.configurations
where name = 'filestream access level';

print '59) See SQL Server Analysis Serverices Operations Guide...'
print ' '

print '61) Ensure permissions for SQL Files, Registry Keys and Data/Log Files are set properly'
print ' '
print ' -- Permissions/Privileges for SQL Server Service Accounts'
print ' '
print ' -- File Locations and Permissions'
print ' '

--Instid =

--  MSSQLServer
--    Instid\MSSQL\backup
--    Instid\MSSQL\binn
--    Instid\MSSQL\data
--    Instid\MSSQL\FTData
--    Instid\MSSQL\Install
--    Instid\MSSQL\Log
--    Instid\MSSQL\Repldata
--    100\shared
--    Instid\MSSQL\Template Data (SQL Server Express Only)

--  SQLServerAgent
--    Instid\MSSQL\binn
--    Instid\MSSQL\Log
--    100\com
--    100\shared
--    100\shared\Errordumps
--    ServerName\EventLog

--  FTS
--    Instid\MSSQL\FTData
--    Instid\MSSQL\FTRef
--    100\shared
--    100\shared\Errordumps
--    Instid\MSSQL\Install
--    Instid\MSSQL\jobs

--  MSSQLServerOLAPservice
--    100\shared\ASConfig
--    Instid\Olap
--    Instid\Olap\Data
--    Instid\Olap\Log
--    Instid\Olap\Backup
--    Instid\Olap\Temp
--    100\shared\Errordumps

--  SQLServerReportServerUser
--    Instid\Reporting Services\Log Files
--    Instid\Reporting Services\ReportServer
--    Instid\Reporting Services\ReportServer\global.asax
--    Instid\Reporting Services\ReportServer\Reportserver.config
--    Instid\Reporting Services\ReportManager
--    Instid\Reporting Services\RSTempfiles
--    100\shared
--    100\shared\Errordumps

--  MSDTSServer100
--    100\dts\binn\MsDtsSrvr.ini.xml
--    100\dts\binn
--    100\shared
--    100\shared\Errordumps

--  SQL Server Browser
--    100\shared\ASConfig
--    100\shared
--    100\shared\Errordumps

--  MSADHelper - N/A (Runs under Network Service account)

--  SQLWriter - N/A (Runs as local system)

--  User
--    Instid\MSSQL\binn
--    Instid\Reporting Services\ReportServer
--    Instid\Reporting Services\ReportServer\global.asax
--    Instid\Reporting Services\ReportManager
--    Instid\Reporting Services\ReportManager\pages
--    Instid\Reporting Services\ReportManager\Styles
--    100\dts
--    100\tools
--    90\tools
--    80\tools
--    100\sdk
--    Microsoft SQL Server\100\Setup Bootstrap

print ' -- Data and Log File(s) Information (see also 47)'
print 'Ensure the permissions are set properly for the Directory/File location returned'
print ' '
select substring(name, 1, 30) as Database_Name,
	substring(physical_name, 1, 90) as Current_Location,
	substring(state_desc, 1, 12) as State
from sys.master_files;
--where database_id = DB_ID(N'<database_name');

print '69) Server Configuration Options'
print '  Using - Master'
print ' '
use master;
select name as Configuration_Option,
	substring(convert(char, value_in_use), 1, 16) as Current_Setting
from sys.configurations
order by name;

print '70) Remote Access setting.  If not set to 0, then it is a Finding'
print '  Using - Master'
print ' '
use master;
select name as Configuration_Option,
	substring(convert(char, value_in_use), 1, 16) as Current_Setting,
	substring(description, 1, 40) as Description,
	is_dynamic,
	is_advanced
from sys.configurations
where name = 'remote access';

print '72) Linked Server - Determine if Linking is being used, enabled'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 30) as Server_Name,
	substring(convert(char, is_linked), 1, 10) as Is_Linked
from sys.servers;

print '75) Database Configuration Options'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 15) as Database_Name,
	is_auto_close_on,
	is_auto_create_stats_on,
	is_auto_update_stats_on,
	is_auto_shrink_on,
	is_auto_update_stats_async_on,
	is_cursor_close_on_commit_on,
	is_local_cursor_default,
	substring(state_desc, 1, 10),
	is_read_only,
	substring(user_access_desc,1, 18),
	is_date_correlation_on,
	is_db_chaining_on,
	is_trustworthy_on,
	is_parameterization_forced,
	substring(recovery_model_desc, 1, 20),
	substring(page_verify_option_desc, 1, 25),
	is_broker_enabled,
	substring(snapshot_isolation_state_desc, 1, 30),
	is_read_committed_snapshot_on,
	is_ansi_null_default_on,
	is_ansi_nulls_on,
	is_ansi_padding_on,
	is_ansi_warnings_on,
	is_arithabort_on,
	is_concat_null_yields_null_on,
	is_quoted_identifier_on,
	is_numeric_roundabort_on,
	is_recursive_triggers_on
from sys.databases;

print '76) Broker Enabled must be set to False (0)'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 15) as Database_Name,
	is_broker_enabled
from sys.databases;

print '78, 79, & 80) Location Data and Log Files (Dup of 47)'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(name, 1, 13) as Logical_Name,
	substring(type_desc, 1, 12) as Type,
	substring(state_desc, 1, 17) as State,
	substring(physical_name, 1, 90) as File_Location
from sys.database_files;

print '81 & 82) SQL SA Account - Needs to be renamed and disabled'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 15) as Principal_Name, 
	principal_id,
	substring(sid, 1, 10) as sid,
	substring(type_desc, 1, 35) as Type,
	substring(default_database_name, 1, 20) as Default_Database,
	is_disabled,
	is_policy_checked,
	is_expiration_checked
from sys.sql_logins
where principal_id = 1;

print '83, 84 & 85) SQL Login Accounts'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 15) as Principal_Name,
	principal_id,
	substring(sid, 1, 10) as sid,
	substring(type_desc, 1, 35) as Type,
	substring(default_database_name, 1, 20) as Default_Database,
	is_disabled,
	is_policy_checked,
	is_expiration_checked
from sys.sql_logins
where type_desc = 'SQL_LOGIN';

print '87) List Server Roles and who has Access, Permissions'
print '  Using - Master'
print ' '
use master;
select substring(s1.name, 1, 20) as Server_Role,
	substring(s2.name, 1, 30) as 'User'
from sys.server_role_members,
	sys.server_principals as s1,
	sys.server_principals as s2
where role_principal_id = s1.principal_id
  and member_principal_id = s2.principal_id
order by Server_Role;

print '88) List Database Roles and who has access, permissions'
print '  Using - Master'
print ' '
use master;
SELECT substring(ROL.name, 1, 20) AS RoleName,
	ROL.is_fixed_role AS Is_Fixed_DB_Role,
	substring(MEM.name, 1, 20) AS MemberName,
	substring(MEM.type_desc, 1, 15) AS MemberType,
	substring(MEM.default_schema_name, 1, 15) AS DefaultSchema, 
	substring(SP.name, 1, 15) AS ServerLogin 
FROM sys.database_role_members AS DRM 
     INNER JOIN sys.database_principals AS ROL 
         ON DRM.role_principal_id = ROL.principal_id 
     INNER JOIN sys.database_principals AS MEM 
         ON DRM.member_principal_id = MEM.principal_id 
     INNER JOIN sys.server_principals AS SP 
         ON MEM.[sid] = SP.[sid] 
ORDER BY RoleName,
	MemberName;

print '89-92) List Custom Database Roles'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(name, 1, 20) as Custom_DB_Role
from sys.database_principals
where type_desc = 'DATABASE_ROLE'
  and name <> 'public'
  and is_fixed_role <> 1
order by Custom_DB_Role;

print ' '
print '95) List Application Roles (Not allowed - any listed = Finding)'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(name, 1, 20) as Application_Role
from sys.database_principals
where type_desc = 'APPLICATION_ROLE';

print '98) Default Schema Information for DB Users'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(name, 1, 20) as Principal_Name,
	substring(type_desc, 1, 20) as Type,
	substring(default_schema_name, 1, 15) as Default_Schema
from sys.database_principals
where type in ('S', 'U', 'A')
order by Principal_Name;

print ' '
print ' -- List of Schemas'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(s.name, 1, 20) as Schema_Name,
	substring(dbp.name, 1,20) as Owner
from sys.schemas as s,
	sys.database_principals as dbp
where dbp.principal_id = s.principal_id
  and dbp.is_fixed_role <> 1
order by s.name;

print '99) List Credentials'
print '  Using - Master'
print ' '
use master;
select substring(name, 1, 20) as Credential_Name,
	substring(credential_identity, 1, 20) as Credential_Identity
from sys.credentials;

print '100) List Server Permissions'
print '  Using - Master'
print ' '
use master;
select substring(srvperm.class_desc, 1, 20) as Class,
	substring(srvprin1.name, 1, 40) as Grantor,
	substring(srvprin2.name, 1, 40) as Grantee,
	substring(srvperm.state_desc, 1, 20) as Permission_State,
	substring(srvperm.permission_name, 1, 30) as Permission
from sys.server_permissions as srvperm,
	sys.server_principals as srvprin1,
	sys.server_principals as srvprin2
where srvperm.grantor_principal_id = srvprin1.principal_id
  and srvperm.grantee_principal_id = srvprin2.principal_id;

print ' -- List Database Permissions'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(dbperm.class_desc, 1, 20) as Class,
	substring(dbprin1.name, 1, 40) as Grantor,
	substring(dbprin2.name, 1, 40) as Grantee,
	substring(dbperm.state_desc, 1, 20) as State,
	substring(dbperm.permission_name, 1, 30) as Permission
from sys.database_permissions as dbperm,
	sys.database_principals as dbprin1,
	sys.database_principals as dbprin2
where dbperm.grantor_principal_id = dbprin1.principal_id
  and dbperm.grantee_principal_id = dbprin2.principal_id;

print ' -- List Built-In Permissions'
print '  Using - Master'
print ' '
use master;
select substring(class_desc, 1, 20) as Securable_Class,
	substring(permission_name, 1, 30) as Permission,
	substring(covering_permission_name, 1, 30),
	substring(parent_class_desc, 1, 30),
	substring(parent_covering_permission_name, 1, 35)
from sys.fn_builtin_permissions(default)
order by class_desc,
	permission_name;

print '102 & 103) List Network Protocols and EndPoints'
print '  Using - Master'
print ' - Use SQL Server Configuration Manager to see the True/Actual Protocol Configuration'
print ' '
use master;
SELECT substring(des.login_name, 1, 20) as Login_Name,
	substring(des.host_name, 1, 20) as Host_Name,
	substring(program_name, 1, 50) as Program_Name,
	substring(dec.net_transport, 1, 15) as Net_Transport,
--	des.login_time,
	substring(e.name, 1, 30) AS Endpoint_Name,
	substring(e.protocol_desc, 1, 15) as Protocol_Desc,
	substring(e.type_desc, 1, 20) as Type_Desc,
	substring(e.state_desc, 1, 12) as State_Desc,
	e.is_admin_endpoint,
	t.port,
	t.is_dynamic_port,
	substring(dec.local_net_address, 1, 20) as Local_Net_Address,
	dec.local_tcp_port 
FROM sys.endpoints AS e
LEFT JOIN sys.tcp_endpoints AS t
   ON e.endpoint_id = t.endpoint_id
LEFT JOIN sys.dm_exec_sessions AS des
   ON e.endpoint_id = des.endpoint_id
LEFT JOIN sys.dm_exec_connections AS dec
   ON des.session_id = dec.session_id;

print ' -- Information about Current Connection'
print '  Using - Master'
print ' '
use master;
SELECT substring(des.login_name, 1, 20) as Login_Name,
	substring(des.host_name, 1, 20) as Host_Name,
	substring(program_name, 1, 50) as Program_Name,
	substring(dec.net_transport, 1, 15) as Net_Transport,
--	des.login_time,
	substring(e.name, 1, 30) AS Endpoint_Name,
	substring(e.protocol_desc, 1, 15) as Protocol_Desc,
	substring(e.type_desc, 1, 20) as Type_Desc,
	substring(e.state_desc, 1, 12) as State_Desc,
	e.is_admin_endpoint,
	t.port,
	t.is_dynamic_port,
	substring(dec.local_net_address, 1, 20) as Local_Net_Address,
	dec.local_tcp_port 
FROM sys.endpoints AS e
LEFT JOIN sys.tcp_endpoints AS t
   ON e.endpoint_id = t.endpoint_id
LEFT JOIN sys.dm_exec_sessions AS des
   ON e.endpoint_id = des.endpoint_id
LEFT JOIN sys.dm_exec_connections AS dec
   ON des.session_id = dec.session_id
where des.session_id = @@SPID;

print ' -- Endpoint(s) that uses the HTTP Protocol'
print '  Using - Master'
print ' '
use master;
select * from sys.http_endpoints;

print '106, 107 & 108) List Schemas, the Owner and whether Login is Disabled'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(s.name, 1, 20) as Schema_Name,
	substring(sp.name, 1, 20) as Owner,
	sp.is_disabled
from sys.schemas as s,
	sys.server_principals as sp
where sp.principal_id = s.principal_id;

print '114) List Accounts that have GRANT WITH GRANT OPTION'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select substring(dbperm.class_desc, 1, 20) as Class,
	substring(dbprin1.name, 1, 40) as Grantor,
	substring(dbprin2.name, 1, 40) as Grantee,
	substring(dbperm.state_desc, 1, 20) as State,
	substring(dbperm.permission_name, 1, 30) as Permission
from sys.database_permissions as dbperm,
	sys.database_principals as dbprin1,
	sys.database_principals as dbprin2
where dbperm.grantor_principal_id = dbprin1.principal_id
  and dbperm.grantee_principal_id = dbprin2.principal_id
  and dbperm.state_desc = 'GRANT_WITH_GRANT_OPTION';

print '121) List Custom Stored Procedures, Triggers and Functions'
print '  Using - <Database_Name>'
print ' - If Definition is NOT NULL, then text is NOT obfuscated via the WITH ENCRYPTION option, and is a Finding'
print ' '
use MISImportStaging;
select sm.object_id as Object_Id,
	substring(o.name, 1, 30) as Object_Name,
	substring(o.type_desc, 1, 30) as Type_Desc,
	substring(sm.definition, 1, 40) as Definition
from sys.sql_modules as sm,
	sys.objects as o
where o.object_id = sm.object_id
  and o.type in ('P', 'PC', 'X', 'TA', 'TR', 'AF', 'FN', 'FS', 'FT', 'IF', 'TF')
order by o.type;

print '122) List Custom EXTENDED Stored Procedures.  If any exist, it is a Finding'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select sm.object_id as Object_Id,
	substring(o.name, 1, 30) as Object_Name,
	substring(o.type_desc, 1, 30) as Type_Desc,
	substring(sm.definition, 1, 40) as Definition
from sys.sql_modules as sm,
	sys.objects as o
where o.object_id = sm.object_id
  and o.type in ('X');

print '126) Determine if FIPS 140-2 is Enabled'
print ' - if not then this and other Item #s could be a Finding'
print ' '
print '-- Run VBS Script, Read_FIPS_RegKey_Setting.vbs'
print ' '

print '130) Full-Text settings'
print '  Using - <Database_Name>'
print ' '
use MISImportStaging;
select fulltextserviceproperty('IsFullTextInstalled') as IsFullTextInstalled;
print ' '
print 'if IsFullTextInstalled = 1, then Full-Text is installed'
print ' '
select fulltextserviceproperty('VerifySignature') as Is_VerifySignature_Enabled;
print ' '
print 'if VerifySignature is NOT set to 1, then this is a Finding as it is not set to the default'
print ' '
select fulltextserviceproperty('LoadOSResources') as Is_LoadOSResources_Disabled;
print ' '
print 'if LoadOSResources is NOT set to 0, then this is a Finding as it is not set to the default'
print ' '

print '131) See if anyone is assigned to the Server Agent Roles that are defined in the msdb database.'
print 'If no one is defined, then Least Privilege is not being used for Server Agent Jobs.'
print '  Using - MSDB'
print ' '
use msdb;
SELECT substring(ROL.name, 1, 20) AS RoleName,
	ROL.is_fixed_role AS Is_Fixed_DB_Role,
	substring(MEM.name, 1, 20) AS MemberName,
	substring(MEM.type_desc, 1, 15) AS MemberType,
	substring(MEM.default_schema_name, 1, 15) AS DefaultSchema, 
	substring(SP.name, 1, 15) AS ServerLogin 
FROM sys.database_role_members AS DRM 
     INNER JOIN sys.database_principals AS ROL 
         ON DRM.role_principal_id = ROL.principal_id 
     INNER JOIN sys.database_principals AS MEM 
         ON DRM.member_principal_id = MEM.principal_id 
     INNER JOIN sys.server_principals AS SP 
         ON MEM.[sid] = SP.[sid]
where Rol.Name in ('SQLAgentUserRole', 'SQLAgentReaderRole', 'SQLAgentOperatorRole') 
ORDER BY RoleName,
	MemberName;

print '134 & 135) SQL Server Agent Job Information'
print '  Using - MSDB'
print ' '
use msdb;
declare @print_msg nvarchar(70)
declare @job_id uniqueidentifier
declare @job_id_str varchar(60)
declare @job_name sysname
declare job_info cursor
   for select job_id, name from msdb.dbo.sysjobs

open Job_info

fetch next from job_info into @job_id, @job_name
while @@fetch_status >= 0
   begin
	set @job_id_str = convert(char(255), @job_id)
	set @print_msg = 'Job_ID = ' + @job_id_str
	print @print_msg
	set @print_msg = 'Job_Name = ' + @job_name
	print @print_msg
	print 'Job Steps = '
	select step_id,
		step_name,
		subsystem,
		database_name,
		database_user_name
	from msdb.dbo.sysjobsteps
	where job_id = @job_id
	print ' '
	fetch next from job_info into @job_id, @job_name
   end
close job_info
deallocate job_info
go

print '136) Search Windows Services for "SQL Server Agent" and see what the "Log On As" is set to'
print 'Do Not use Local System, Network Service, or Local Service.  The account used CAN NOT be'
print 'a member of the Windows Administrators group.'
print ' '

print '137, 138 & 139) Audit Information -- more work is needed on this area'
print '  Using - MSDB'
print ' '
use msdb;
select sa.audit_id as Audit_Id,
	sa.name as Audit_Name,
	sa.audit_guid,
	sa.type_desc,
	sa.on_failure_desc as On_Failure,
	sa.is_state_enabled as Is_Enabled,
	sp.name as Owner,
	sp.type_desc as Owner_Type,
	sp.is_disabled as Is_Login_Disabled
from sys.server_audits as sa,
	sys.server_principals as sp
where sp.principal_id = sa.principal_id;

print '147) Change Data Capture and Change Tracking'
print '  Using - MSDB'
print 'if CDC is NOT enabled (0), then Change Data Capture has not been setup, configured, or enabled.'
print ' '
use msdb;
select substring(name, 1, 30) as Database_Name,
	is_cdc_enabled
from sys.databases;

print '148 - 153) Determine if Replication is Enabled'
-- print '  Using - MSDB'
print '  Using - Master'
print 'Note: This needs to be verified and tested further, by running against a DB that has'
print 'replication enabled.  When creating this test, it was on a Server that did not appear'
print 'to have replication enabled.'
print ' '
-- use msdb;
-- if object_id('msdb..msdistpulishers', 'U') is NULL
--  print 'Replication is NOT enabled'
use master;
select substring(name, 1, 30) as Database_Name,
	is_published,
	is_subscribed,
	is_merge_published,
	is_distributor
from sys.databases;

print '154) Determine if Service Broker is Enabled'
print '  Using - Master'
print 'Note: Additional tests need to be created when a System has Service Broker enabled,'
print ' '
use master;
select substring(name, 1, 30) as Database_Name,
	is_broker_enabled
from sys.databases;

print '155) Check Status of Backups'
select 	SUBSTRING(s.name, 1, 30)		AS 'Database',
	CAST(b.backup_start_date AS char(11)) 	AS 'Backup Date',
	CASE WHEN b.backup_start_date > DATEADD(dd, -1, getdate())
		THEN 'Backup is current, within a day'
	     WHEN b.backup_start_date > DATEADD(dd, -7, getdate())
		THEN 'Backup is current, within a week'
	     ELSE '*****CHECK BACKUP!!!*****'
	END AS 'Comment',
	b.recovery_model,
	b.is_password_protected,
	b.is_snapshot,
	b.is_readonly,
	b.is_single_user
from master..sysdatabases s
LEFT OUTER JOIN	msdb..backupset b
	ON s.name = b.database_name
AND b.backup_start_date = (SELECT MAX(backup_start_date)
				FROM msdb..backupset
				WHERE database_name = b.database_name
				AND type = 'D')		-- full database backups only, not log backups
WHERE s.name <> 'tempdb'
ORDER BY s.name;

print '164) Dup of 61'
go
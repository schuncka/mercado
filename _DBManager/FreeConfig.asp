<%'There should be no ASP or HTML codes above this line

'1 Click DB Free copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB Free source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'See License.txt for Open Source License
'More info online at http://1ClickDB.com/
'Email inquiries to info@1ClickDB.com
        
'1 Click DB Free Configuration Variables :

ocdAdminPassword      = "" 'comma delimited list of passwords required to create dynamic connections.  Session cookies required for this option.
ocdADOConnection      = "" ' e.g : "provider=Microsoft.Jet.OLEDB.4.0;data source=c:\inetpub\data\Northwind.mdb;" 'hard coded connection string, if not set session cookies will be used to gather dynamic connection information
ocdADOUsername        = "" 'hard coded db user name, only active if ocdADOConnection is set
ocdADOPassword        = "" 'hard coded db password, only active if ocdADOConnection is set
ocdStyleSheet         = "ocdStyleSheet.css"
ocdBrandLogo          = "" 'Your HTML Link/Logo Here" 'replace "1 Click DB Free" HTML in upper right corner of interface
ocdBrandText          = "" 'replace "1 Click DB Free" TEXT in the interface
ocdReadOnly           = False 'If true, modifications to your database are discouraged.  For better security set user and database permissions as appropriate
ocdPageSizeDefault    = 10 'default page size for browse grids
ocdSessionTimeout     = 50 'Session timeout in minutes
ocdMaxRecordsRetrieve = 10000
ocdMaxRecordsDisplay  = 1200
ocdDBTimeout          = 30 'Seconds before giving up on returning results from an SQL query
ocdComputeTimeout     = 1 'Seconds before giving up on returning results from an computed statistics for a query
ocdMultipleFieldSort  = False 'Set to False for non-additive Order By sorts
ocdGridHighlightSelected = True 'if true, enable highlight selected records in Browse grids
ocdDefaultTextCompare = "Starts With" 'Default comparision operator for text field, valid values are "=","Starts With", "Contains","Like","In","Is Null"
ocdShowDefaults       = True 'Enable display of default values when adding new records
ocdCodePage           = 1252
ocdFormNullToken      = ""
ocdShowRelatedRecords = True	'Show browse of related records from edit screens; Default=true
ocdSelectForeignKey   = True 'Create dropdown select box for picking single field foreign keys, if false show regular text field; Default=true
ocdDisableTextDriver  = True 'Use True to discourage Text driver connections. Remove driver from server when not required or if security is an issue.
ocdShowCheckedSearchFields = True
ocdCharSet            = "iso-8859-1" 
ocdFooterHTML         = ""
ocdUseRegExKeywordSearch = True
ocdShowSQLText        = True
ocdRenderAsHTML       = False 'Warning ! Setting this option to TRUE for untrusted data introduces Cross Site Scripting vulnerabilities.
ocdGridIcons          = False
ocdCompatibility      = 0 '0 or ocdNoFrames or ocdNoJavaScript
'Session.LCID = 1033 'English_United_States locale settings
'Session.LCID = 1033 'BRAZIL locale settings
ocdDebug             = False

'There should be no ASP or HTML Codes below this line %>

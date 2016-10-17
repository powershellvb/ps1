$Url ="http://sp.csd.syscom"
$SPweb = get-spweb  $Url
$SPweb.Lists |select name,title

#$splistmylist = $SPweb.Lists["mylist"] #-as [Microsoft.SharePoint.SPDocumentLibrary]
$splistSharedDocuments = $SPweb.Lists["共享文件"] 
$splistPX1 = $SPweb.Lists["PX1"] 

$SPItems=$splistSharedDocuments.items ; if  ($SPItems -eq $null ){ write  "Null" } else {write $SPItems}
$SPItems=$splistPX1.items ; if  ($SPItems -eq $null ){ write  "Null" } else {write $SPItems}

$ofile=$spitems | ? {$_.name -eq "中式炒面.jpg"} ; if  ($ofile -eq $null ){ write  "Null" } else {write $ofile.name}
$ofile=$spitems | ? {$_.name -eq "生日快樂.jpg"} ; if  ($ofile -eq $null ){ write  "Null" } else {write $ofile.name}


#$ofile.CheckOut()
$fi = $ofile.Item  ; if  ($fi -eq $null ){ write  "Null" } else {write $fi}

$tf       = $ofile.Fields["L1"] 

$tf.SetFieldValue($ofile,$TaxoMarketing)
$tf.SetFieldValue($ofile,$TaxoDelivery)
$tf.SetFieldValue($ofile,$TaxoHR)
$ofile.Update()
#$ofile.CheckIn("")



#Lists$web = get-spweb "http://sp.csd.syscom"$list = $web.Lists["mylist"]#$item = $list.items["t1"] ; $list.items |select name,title
$item = $list.items | ? {$_.name -eq "t1"}
$item["Title"];$item["L1"]
 #Get an item that currently has a value set in the Taxonomy (Managed Metadata) field$taxField = $item.Fields["L1"] -as [Microsoft.SharePoint.Taxonomy.TaxonomyField] $taxFieldValue = $taxField.GetFieldValue("");$taxField.SetFieldValue($item,$Marketing)
$item.Update()
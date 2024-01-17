$filename = read-host "enter file location: "
[xml]$fittings = Get-Content $filename

$fitting_string = "";
foreach($entry in $fittings.fittings.fitting){
    $fitting_name = $entry.name;
    $ship_type = $entry.shiptype.value;
    $fitting_string = $fitting_string + "$fitting_name,$ship_type,1`n"

    $fitting_items = [ordered]@{}
    foreach($item in $entry.hardware){
        if($fitting_items.contains($item.type)){
            $fitting_items[$item.type] = $fitting_items[$item.type] + 1;
            continue;
        }
        $fitting_items[$item.type] = if($item.qty) { $item.qty } else {1};
    }

    foreach($item in $fitting_items.GetEnumerator()) {
        $item_name = $item.key;
        $item_qty = $item.value;
        $fitting_string = $fitting_string + "$fitting_name,$item_name,$item_qty`n"
    }
}

$fitting_string | out-file .\out.csv

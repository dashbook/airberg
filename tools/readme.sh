function schema_markdown(){
    local file=$1;
    
    echo "| Name | Type | Constant | Default | Description |" 
    echo "| --- | --- | --- | --- | --- |"
    echo "$(jq -r '.connectionSpecification | [paths(values) as $path | select($path[-1] == "properties" or $path[-1] == "oneOf") | getpath($path) | to_entries | flatten | map(select(.value | has("properties") | not)) | map({"name": ($path + [.key]) | map(select(. != "properties" and . != "oneOf")) | join("."), "type": .value.type, "constant": .value.const, "default": .value.default, "description": .value.description})] | flatten | map("|" + .name + "|" + .type + "|" + .constant + "|" + (.default | tostring ) + "|" + .description + "|") | join("\n")' $file)";
}

function schema_example(){
    local file=$1;

    echo "$(aichat -f $file Give an example object with the provided JSON schema. Return only JSON without any explanation.)"
}

for file in $(find airbyte-integrations/connectors/ -iname "README_old.md"); do 
    directory=${file/%\/README_old.md/};
    spec=$(find $directory -iname "spec.json" -print -quit);
    name=$(basename $directory);

    if [[ -z $spec ]]; then continue; fi

    spec_table="$(schema_markdown $spec)";

    spec_example="$(schema_example $spec)"

done


#!/bin/bash
# Get all model names from Ollama API
models_response=$(curl -s http://localhost:11434/api/tags)

# Extract model names from the 'models' array using jq
model_names=($(jq -r '.models[].name' <<< "$models_response"))

# Loop through each model name and pull it, capturing the response
for model in "${model_names[@]}"; do
    echo "Pulling model: $model"
    response=$(curl http://localhost:11434/api/pull -s -d '{"model":"'$model'", "stream":false}')
    status_code=$(jq -r '.status' <<< "$response")
    
    if [ "$status_code" = "success" ]; then
        echo -e "Successfully pulled model: $model\n"
    else
        echo -e "Error pulling model $model: Status code: $status_code\n"
    fi
done
eval $(cat $HOME/.zshrc | grep "^export OPENAI")

curl --no-buffer -s ${OPENAI_API_BASE}/openai/deployments/gpt-4-32k/chat/completions?api-version=${OPENAI_API_VERSION}\
  -H "Content-Type: application/json" \
  -H "api-key: ${OPENAI_API_KEY}" \
  -d "{
  \"messages\": [
    {\"role\": \"system\", \"content\": \"You are a helpful assistant\"},
    {\"role\": \"user\", \"content\": [{\"type\":\"text\",\"text\":\"$(cat -)\"}]}
  ],
  \"stream\": true
}"  | sed -u "s/^[^{]*//g"  | jq -j -c --unbuffered ".choices[].delta.content | select (.!=null)" 


# kill it to reopen at every stream update
#ps -eo pid,command | grep " sh ./text_chatgpt_tool.sh" | grep -v grep | awk '{print $1}' | xargs kill

#}" 2>/dev/null | sed "s/^data: //g" | jq -j -c ".choices[].message.content"

# Improve chat continuity using the json below and https://learn.microsoft.com/en-us/azure/ai-services/openai/reference
  #-d '{"messages":[{"role":"system","content":"You are a helpful assistant."},{"role":"user","content":[{"type":"text","text":"Describe this picture:"},{ "type": "image_url", "image_url": { "url": "https://learn.microsoft.com/azure/ai-services/computer-vision/media/quickstarts/presentation.png", "detail": "high" } }]}]}'


json.array!(@events) do |event|
  json.extract! event, :id, :title 
  json.start event.data_inicio  
  json.end event.data_fim 
  json.url event_url(event, format: :html) 
  json.backgroundColor event.cor
  json.borderColor event.cor
end

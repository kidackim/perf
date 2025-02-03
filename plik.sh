"scripts": {
  "test": "powershell -Command \"node auth.ts; Get-Content .env | ForEach-Object { $name, $value = $_ -split '=', 2; Set-Item -Path env:\\$name -Value $value.Trim('\"') }; npx gatling-js run --typescript\""
}

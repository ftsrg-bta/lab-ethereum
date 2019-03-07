:: HTML
pandoc.exe guide.md --from=markdown_github-hard_line_breaks+yaml_metadata_block --output=guide.html --css=pandoc.css --standalone --self-contained
pandoc.exe vulnerabilities.md --from=markdown_github-hard_line_breaks+yaml_metadata_block --output=vulnerabilities.html --css=pandoc.css --standalone --self-contained

:: PDF
pandoc.exe guide.md --from=markdown_github-hard_line_breaks+yaml_metadata_block --output=guide.pdf -V geometry:margin=1in -V urlcolor:blue
pandoc.exe vulnerabilities.md --from=markdown_github-hard_line_breaks+yaml_metadata_block --output=vulnerabilities.pdf -V geometry:margin=1in -V urlcolor:blue
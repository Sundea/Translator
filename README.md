# Translator
Транслятор кастомного языка. Курсовая работа.

Примеры executable кода: 

```
program s @
var, sd, a: integer
begin
!   for a:=1 step 1 to 4 do sd:=a + 1
    next
end
```

```
program s @
var, sd, a, b: integer
begin
!   for a:=1 step 1 to 4 do sd:=a + 1
        for b:=1 step 1 to 3 do sd:= sd * sd
        next
    next
end
```

```
program s @
var, sd, a: integer
begin
!    sd:=3
    if not sd>3 then
!    sd:=4
    write(, sd)
    else
!    sd:=5
    write(, sd)
    endif
end
```

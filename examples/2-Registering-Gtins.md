## Registering GTIN 1

ABC Corp registers GTIN 1.

```
GtinDirectory.register(
  "00006789123456",                           // gtin
  1                                           // endpoint id
)
```
The following event is triggered by the successful execution of the above function.

```
GtinDirectory.Registered (
  "00006789123456",                           // gtin
  "0123"                                      // company prefix of ABC Corp
)
```

# MySQL procedure of querying table from a passing string.

- Implements a function to check if the column is present in the table.
- Loop over multiple columns splited by coma (,).

The select query is directly executed at the end.

# Usage

```mysql
display_cols("country", "id,name")
```

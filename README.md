# database-design-queries
Catalog of PostgreSQL system-catalog based queries for getting an overview of the state of the database design or finding the occurrences of specific problems in it.

## The catalog is <b>HERE</b>. All the queries in the catalog are open source.

### The fresh statistics about the catalog content can be seen from <b>HERE</b>.</p>

The files in the project catalog provide examples.

<ul>
<li><i>Example_smelly</i> - SQL statements for creating PostgreSQL database base tables that have a number of different database design problems.
<li><i>Example_process</i> - The comments bring out design problems in the tables that are presented in the file <i>Example_smelly</i>. The comments refer to the problems by using the initial database object names (identifiers) from the file <i>Example_smelly</i>. The SQL statements in the file codify refactorings that are needed in the database to fix the problems. The statements are ordered, i.e., they take into account changes that have been made in the database schema with the previous statements.
<li><i>Example_cleaned</i> - SQL statements for creating PostgreSQL database base tables where all the problems have been fixed. If one creates tables of <i>Example_smelly</i> and applies changes from <i>Example_process</i>, then the resulting database design is like it is depticted in this file.
</ul>

<ul>
<li><a target=_blank href=https://htmlpreview.github.io/?https://github.com/erki77/database-design-queries/blob/master/example_of_query_results/find_flaws_automatically.htm>HERE</a> is a result of executing the queries from the collection <i>Find flaws automatically</i> based on the database that is depicted in the file <i>Example_smelly</i>.
<li><a target=_blank href=https://htmlpreview.github.io/?https://github.com/erki77/database-design-queries/blob/master/example_of_query_results/find_flaws_by_overview.htm>HERE</a> is a result of executing the queries from the collection <i>Find flaws by overview</i> based on the database that is depicted in the file <i>Example_smelly</i>.
</ul>

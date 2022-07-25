# database-design-queries

## The catalog is <a target=_blank href=https://maurus.ttu.ee/design_queries/>HERE</a>. All the queries in the catalog are open-source.
Among other things there are collections: 
<ul>
  <li>Find problems about integrity constraints
    <li>Find problems about base tables
      </ul>

### The fresh statistics about the catalog content can be seen from <a target=_blank href=https://maurus.ttu.ee/design_queries/statistics/>HERE</a>.

It is a part of the work that has been published in the papers:

<ul>
<li>Eessaar, E., 2020. Automating Detection of Occurrences of PostgreSQL Database Design Problems. In: Databases and Information Systems: 14th International Baltic Conference 2020 (DB&IS 2020), Tallinn, Estonia, June 16–19, 2020. Eds. Robal, T., Haav, H.-M., Penjam, J., Matulevièius, R. Switzerland: Springer International Publishing, ISBN: 978-3-030-57671-4, pp. 276–189. (Communications in Computer and Information Science; 1243) (<a target=_blank href=https://link.springer.com/chapter/10.1007/978-3-030-57672-1_14>SpringerLink</a>)

<li>Eessaar, E., 2021. The Usage of Declarative Integrity Constraints in the SQL Databases of Some Existing Software. In: Software Engineering and Algorithms, Vol 1: 10th Computer Science On-line Conference 2021 (CSOC 2021), April 29, - May 2, 2021. Ed. Silhavy, R. Switzerland: Springer International Publishing, ISBN: 978-3-030-77441-7, pp. 375-390. (Lecture Notes in Networks and Systems: 230) (<a target=_blank href=https://link.springer.com/chapter/10.1007/978-3-030-77442-4_33>SpringerLink</a>)
  
<li>Eessaar, E., 2022. On the Design of Base Tables in the SQL Databases of Some Existing Software. In: Software Engineering Perspectives in Systems, Vol 1: 11th Computer Science On-line Conference 2022 (CSOC 2022), April 26, - April 30, 2022. Ed. Silhavy, R. Switzerland: Springer International Publishing, ISBN: 978-3-031-09069-1, pp. 309-324. (Lecture Notes in Networks and Systems: 501) (2022) (<a target=_blank href=https://link.springer.com/chapter/10.1007/978-3-031-09070-7_26>SpringerLink</a>). 
</ul>

Additional materials to the catalog of PostgreSQL system-catalog based queries that are used for getting an overview of the state of the database design or finding the occurrences of specific problems in it.

The files in the project catalog provide examples.

<ul>

<li><a target=_blank href=https://github.com/erki77/database-design-queries/blob/master/Example_smelly.sql>Example_smelly</a> - SQL statements for creating PostgreSQL database base tables that have a number of different database design problems. The statements are syntactically correct. Quite probably one could even implement a working software on top of these. However, the design has many problems that make it more difficult to understand, learn, use, maintain, and extend the database and software that uses it.

<li><a target=_blank href=https://github.com/erki77/database-design-queries/blob/master/Example_process.sql>Example_process</a> - The comments bring out design problems in the tables that are presented in the file <i>Example_smelly</i>. The comments refer to the problems by using the initial database object names (identifiers) from the file <i>Example_smelly</i>. The SQL statements in the file codify refactorings that are needed in the database to fix the problems. The statements are ordered, i.e., they take into account changes that have been made in the database schema with the previous statements.

<li><a target=_blank href=https://github.com/erki77/database-design-queries/blob/master/Example_cleaned.sql>Example_cleaned</a> - SQL statements for creating PostgreSQL database base tables where all the problems have been fixed. If one creates tables of <i>Example_smelly</i> and applies changes from <i>Example_process</i>, then the resulting database design is like it is depticted in this file.
</ul>

<ul>
<li><a target=_blank href=https://htmlpreview.github.io/?https://github.com/erki77/database-design-queries/blob/master/example_of_query_results/find_problems_automatically.htm>HERE</a> is a result of executing the queries from the collection <i>Find flaws automatically</i> based on the database that is depicted in the file <i>Example_smelly</i>.

<li><a target=_blank href=https://htmlpreview.github.io/?https://github.com/erki77/database-design-queries/blob/master/example_of_query_results/find_problems_by_overview.htm>HERE</a> is a result of executing the queries from the collection <i>Find flaws by overview</i> based on the database that is depicted in the file <i>Example_smelly</i>.
</ul>

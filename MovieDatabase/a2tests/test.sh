#!/bin/bash

# !!! You have to make changes here!!!
username=liudavid        # Change this to your CDF account
database=csc343h-liudavid    # Change this your database name 'csc343h-cdf_account'
passwd=''          # Leave this alone (you don't have a password)


# You don't have to make any changes from this line onwards.
current=`pwd`
result=$current/result
questions=('q1' 'q2' 'q3' 'q4' 'q5')
rm result

#$1: database name
function init
{
    psql -U $username -d $1 -f $current/imdb.ddl
    psql -U $username -d $1 -f $current/db-sample.sql
}

touch result
#$1: database name
function test_part1
{
    for ans in ${questions[@]}
    do
    echo "-----------------------------------" >> $result
    echo "         TESTING FOR ${ans}.sql    " >> $result
    echo "-----------------------------------" >> $result
    if [ ! -f ${ans}.sql ]; then
        echo "Unable to find ${ans}.sql... " >> $result
    else
        echo "$ans exists." >> $result
        psql -U $username -d $1 -f $current/${ans}.sql >> .table.your
        echo "******** YOUR RESULT ********" >> $result
        sed -i '/^SET/d' .table.your
        sed -i '/^DROP VIEW/d' .table.your
        sed -i '/^CREATE VIEW/d' .table.your
        less .table.your >> $result
        echo >> $result

        echo "******** EXPECTED RESULT ********" >> $result
        less ${ans}.ans >> $result
        echo >> $result

        if [ -z `diff -q .table.your ${ans}.ans` ]; then
            echo "Correct Answer" >> $result
        else
            echo "Wrong Answer" >> $result
        fi
        echo >> $result

        rm -f .table.your
        rm -f temp
    fi
    done

    echo "-----------------------------------" >> $result
    echo "         TESTING FOR q6.sql        " >> $result
    echo "-----------------------------------" >> $result
    if [ ! -f q6.sql ]; then
        echo "Unable to find q6.sql... " >> $result
    else
        echo "q6.sql exists." >> $result
        psql -U $username -d $database -c "select * from imdb.movies order by movie_id;" >> .table.old 2>&1
        psql -U $username -d $1 -f $current/q6.sql >> temp
        psql -U $username -d $database -c "select * from imdb.movies order by movie_id;" >> .table.new 2>&1
        echo "******** OLD TABLE ********" >> $result
        less .table.old >> $result

        echo "******** NEW TABLE ********" >> $result
        less .table.new >> $result
        echo >> $result

        echo "******** EXPECTED NEW TABLE ********" >> $result
        less q6.ans >> $result
        echo >> $result

        if [ -z `diff -q .table.new q6.ans` ]; then
            echo "Correct Answer" >> $result
        else
            echo "Wrong Answer" >> $result
        fi
        echo >> $result

        rm -f .table.old
        rm -f .table.new
        rm -f temp
    fi
}

function test_part2
{
    javac TestAssignment2.java Assignment2.java >> $result 2>&1
    java -cp /local/packages/jdbc-postgresql/postgresql-8.4-701.jdbc4.jar:. TestAssignment2 $database $username $passwd >> $result 2>&1
    rm -rf *.class
}

cd $current
init $database > temp
rm -f temp
test_part1 $database
test_part2

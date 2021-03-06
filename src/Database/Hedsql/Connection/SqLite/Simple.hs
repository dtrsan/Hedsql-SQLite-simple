{-# LANGUAGE FlexibleContexts  #-}

{-|
Module      : Database/Hedsql/Connection/SqLite/Simple
Description : Use of Hedsql with SQLite-simple package.
Copyright   : (c) Leonard Monnier, 2015
License     : GPL-3
Maintainer  : leonard.monnier@gmail.com
Stability   : experimental
Portability : portable

Collection of functions allowing a direct use of Hedsql with a SQLite
database through SQLite-Simple library.

* Examples
TODO

* Notes
Database.SQLite.Simple and Database.SQLite.Simple.FromRow packages are
already included in this module, so no needs to re-import them.
Same for Hedsql.
-}
module Database.Hedsql.Connection.SqLite.Simple
    ( module Database.SQLite.Simple.FromRow
    , module S
    , module H
    , createTable
    , delete
    , dropTable
    , insert
    , selectOne
    , selectAll
    , update
    ) where

--------------------------------------------------------------------------------
-- IMPORTS
--------------------------------------------------------------------------------

import           Data.Text.Lazy (Text, toStrict)
import           Database.SQLite.Simple.FromRow
import qualified Database.Hedsql.SqLite          as H
import qualified Database.SQLite.Simple          as S

--------------------------------------------------------------------------------
-- PRIVATE
--------------------------------------------------------------------------------

-- | Execute a statement not returning result.
execute :: H.ToStmt a (H.Statement H.SqLite) => S.Connection -> a -> IO ()
execute conn query = S.execute_ conn $ toQuery $ H.parse query

-- | Convert a string to a Query.
toQuery :: Text -> S.Query
toQuery = S.Query . toStrict

--------------------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------------------

-- | Create a table.
createTable :: S.Connection -> H.CreateStmt H.SqLite -> IO ()
createTable = execute

-- | Delete values in a table.
delete :: S.Connection -> H.DeleteStmt colType H.SqLite -> IO ()
delete = execute

-- | Drop a table.
dropTable :: S.Connection -> H.Drop H.SqLite -> IO ()
dropTable = execute

-- | Insert values in a table.
insert :: S.Connection -> H.InsertStmt colType H.SqLite -> IO ()
insert = execute

-- | Return the first row of a SELECT query's result.
selectOne :: FromRow r => S.Connection -> H.Query colType H.SqLite -> IO r
selectOne conn query = fmap head $ S.query_ conn $ toQuery $ H.parse query

{-|
Return all rows of a SELECT query's result.

Note: since this function uses query_ and not fold_, it should not be used
for big results.
-}
selectAll :: FromRow r => S.Connection -> H.Query colType H.SqLite -> IO [r]
selectAll conn query = S.query_ conn $ toQuery $ H.parse query

-- | Update the values of a table.
update :: S.Connection -> H.UpdateStmt colType H.SqLite -> IO ()
update = execute

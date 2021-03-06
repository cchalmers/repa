
-- | Sum up segments of doubles according to a segment descriptor file.
--   The number of values written to the output is equal to the number
--   of segments defined by the segments file.
--
-- @ 
--   fileInSegs  fileInVals  fileOutSums
--   ----------  ----------  -----------
--   0           1           
--   0           2           3
--   1           3 
--   1           4           7
--   0           5
--   0           6
--   0           7           18
--   1           8           8
--
-- @
--
module Main where
import Data.Repa.Flow                           as F
import Data.Repa.IO.Convert                     as A
import System.Environment
import Data.Char
import Data.Word
import Prelude


main :: IO ()
main 
 = do   args    <- getArgs
        case args of
         [fiNames, fiVals, foNames, foSums]      
           -> pGroupSum fiNames fiVals foNames foSums
         _ -> dieUsage


-- | Sum up segments of doubles according to a segment descriptor file.
pGroupSum :: FilePath -> FilePath -> FilePath -> FilePath -> IO ()
pGroupSum fiNames fiVals foNames foSums
 = do   
        -- Read names and values from files.
        iNames  <-  fromFiles [fiNames] sourceLines

        iVals   <-  map_i U readDouble 
                =<< fromFiles [fiVals]  sourceLines

        -- Sum up the values segment-wise.
        iAgg    <-  foldGroupsBy_i B U (==) (+) 0 iNames iVals

        -- Write group names and sums back to files.
        oNames  <-  map_o name fst
                =<< toFiles [foNames] (sinkLines B F)

        oSums   <-  map_o name (showDoubleFixed 4 . snd) 
                =<< toFiles [foSums]  (sinkLines B F)

        oAgg    <-  dup_oo oNames oSums

        -- Drain all the source data into the sinks.
        drainS iAgg oAgg


dieUsage
 = error $ unlines
 [ "flow-groupsum <src_names> <src_vals> <dst_names> <dst_vals>" ]

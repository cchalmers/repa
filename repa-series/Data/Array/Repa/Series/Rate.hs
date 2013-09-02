
module Data.Array.Repa.Series.Rate
        ( RateNat (..)
        , rateOfRateNat

        , Down2 (..),   Down4 (..)    
        , Tail2 (..),   Tail4 (..))
where
import GHC.Exts

-- | Holds the value-level version of a type-level rate variable.
--
--   All the functions in the repa-series API ensures that the value-level and
--   type-level rates match up. 
--
--   Should be treated abstactly by user code.
--
data RateNat k
        = RateNat Word#


rateOfRateNat :: RateNat k -> Word#
rateOfRateNat (RateNat len) 
        = len
{-# INLINE rateOfRateNat #-}


-- Represents the quotient of a rate divided by the multiplier.
-- Should be treated abstractly by client code.
data Down2 k
data Down4 k


-- | Represents the remainder of a rate divided by the multiplier.
-- 
--   Contains the starting offset in the original vector, 
--   and number of elements.
--
--   Should be treated abstractly by client code.
--
data Tail2 k
data Tail4 k



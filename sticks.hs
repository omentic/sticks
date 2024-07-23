{-# LANGUAGE OverloadedStrings #-}

import Hakyll

-- Applies the template specified in a post's metadata, if it exists
applyMetadataTemplate :: Context String -> Item String -> Compiler (Item String)
applyMetadataTemplate context item = do
  field <- getMetadataField (itemIdentifier item) "template"
  case field of
    Just path ->
      let templatePath = "_templates/" ++ path ++ ".html" in
      loadAndApplyTemplate (fromFilePath templatePath) context item
    _ -> return item

main :: IO ()
main = hakyll $ do
  -- Compile templates for future use
  match "_templates/*" $ compile templateBodyCompiler

  -- Detect whether HTML files are standalone or in need of a template
  match ("**.html" .||. "**.htm") $ do
    route idRoute
    compile $ do
      identifier <- getUnderlying
      field <- getMetadataField identifier "layout"
      case field of
        Just _ -> pandocCompiler
        Nothing -> getResourceBody
      >>= applyMetadataTemplate defaultContext
      >>= relativizeUrls

  -- Match all other renderable files and apply their template, if it exists
  match ("**.md" .||. "**.rst" .||. "**.org" .||. "**.adoc") $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= applyMetadataTemplate defaultContext
      >>= relativizeUrls

  -- Additionally copy non-HTML files verbatium
  match ("**.md" .||. "**.rst" .||. "**.org" .||. "**.adoc") $ version "raw" $ do
    route idRoute
    compile pandocCompiler

  -- Copy all additional files verbatium
  match "**" $ do
    route idRoute
    compile copyFileCompiler

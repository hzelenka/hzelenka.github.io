{-# LANGUAGE OverloadedStrings  #-}

import Hakyll
import Text.Pandoc.Options
import Data.Monoid (mappend)
import qualified Data.Set as S

main :: IO ()
main = hakyll $ do
  match "/images/*" $ do
    route idRoute
    compile copyFileCompiler
  match "/css/*" $ do
    route   idRoute
    compile compressCssCompiler
  match (fromList ["about.rst"]) $ do
    route   $ setExtension "html"
    compile $ pandocMathCompiler
              >>= loadAndApplyTemplate "templates/default.html" defaultContext
              >>= relativizeUrls
  match "/posts/*" $ do
    route $ setExtension "html"
    compile $ pandocMathCompiler
              >>= loadAndApplyTemplate "templates/post.html"    postCtx
              >>= loadAndApplyTemplate "templates/default.html" postCtx
              >>= relativizeUrls
  create ["/resume.markdown"] $ do
    route $ setExtension "html"
    compile $ do
      let resumeCtx = constField "title" "Resume" `mappend` defaultContext
      pandocMathCompiler
        >>= applyAsTemplate resumeCtx
        >>= loadAndApplyTemplate "templates/default.html" resumeCtx
        >>= relativizeUrls
  create ["/archive.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let archiveCtx = listField "posts" postCtx (return posts) `mappend`
                       constField "title" "Archives"            `mappend`
                       defaultContext
      makeItem "" >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                  >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                  >>= relativizeUrls
  match "/index.html" $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let indexCtx = listField "posts" postCtx (return posts) `mappend`
                     constField "title" "Home"                `mappend`
                     defaultContext
      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls
  match "/templates/*" $ compile templateBodyCompiler

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

config :: Configuration
config = defaultConfiguration
  { deployCommand = "bash deploy.sh setup && bash deploy.sh deploy" }

pandocMathCompiler =
    let mathExtensions = [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                          Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = foldr S.insert defaultExtensions mathExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

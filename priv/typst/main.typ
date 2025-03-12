#import sys.inputs.templatePath: blog-from-metadata


#let meta = json.decode(sys.inputs.blogJson)
#blog-from-metadata(meta, apply-default-style: true)
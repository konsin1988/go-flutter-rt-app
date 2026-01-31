package texx 

import (
  _ "time"
  "konsin1988/rt-app/types"
)

type GhostPost struct {
    ID		  string  `json:"id"`
    Title	  string  `json:"title"`
    HTML	  string  `json:"html"`
    Slug	  string  `json:"slug"`
    FeatureImage  string  `json:"feature_image"`
}

type GhostPostResponse struct {
    Posts []GhostPost `json:"posts"`
}

type TexxPost struct {
    DocumentId	  string	    `json:"documentId"`
    Title	  string	    `json:"Title"`
    Slug	  string	    `json:"Slug"`
    PublishedAt	  types.DateOnly    `json:"Date"`
    PreviewImage  PreviewImage	    `json:"PreviewImage"`
    Content	  []TexxPostContent `json:"Content"`
}

type TexxPostContent struct {
    ContentType	  string	      `json:"type"`
    ContentChildren	  []ContentChildren   `json:"children"`
}

type ImageFormat struct {
    Small     SmallType	  `json:"small"`
}

type SmallType struct {
    Url	      string	`json:"url"`
}

type PreviewImage struct {
  Formats	ImageFormat  `json:"formats"`
}

type ContentChildren  struct {
    ChildrenType    string	      `json:"type"`
    ChildrenText    string	      `json:"text"`
    LinkChildren    []LinkChildren    `json:"children, omitempty"`
}

type LinkChildren struct {
    LinkText	string	`json:"text"`
}

type TexxPostResponse struct {
    Posts []TexxPost  `json:"data"`
}

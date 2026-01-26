package post

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


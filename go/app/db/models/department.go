package models


type Department struct {
  ID	    int		`json:"id"`
  Name	    string	`json:"name"`
  Parent    int		`json:"parent,omitempty"`
  Head	    int		`json:"head,omitempty"`
}


type DeptById struct {
  ID		int		`json:"id"`
  Name		string		`json:"name"`
  Parent	int		`json:"parent,omitempty"`
  ParentName	string		`json:"parent_name,omitempty"`
  Head		int		`json:"head,omitempty"`
  HeadFIO	int		`json:"head_fio,omitempty"`
  DeptUserList	[]DeptUser
}

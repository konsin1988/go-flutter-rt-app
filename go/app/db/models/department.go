package models


type Department struct {
  ID	    int		`json:"id"`
  Name	    string	`json:"name"`
  Parent    int		`json:"parent,omitempty"`
  Head	    int		`json:"head,omitempty"`
}


type DeptById struct {
  ID		int32		`json:"id"`
  Name		string		`json:"name"`
  Parent	int32		`json:"parent,omitempty"`
  ParentName	string		`json:"parent_name,omitempty"`
  Head		int32		`json:"head,omitempty"`
  HeadFIO	string		`json:"head_fio,omitempty"`
  DeptUserList	[]DeptUser
}

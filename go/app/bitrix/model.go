package bitrix

import (
)


type BitrixUser struct {
  ID		  string      `json:"ID"`   
  Name		  string      `json:"NAME"`
  LastName	  string      `json:"LAST_NAME"`   
  SecondName	  string      `json:"SECOND_NAME"`    
  Email		  string      `json:"EMAIL"`   
  PersonalPhoto	  string      `json:"PERSONAL_PHOTO"`   
  Birthday	  string      `json:"PERSONAL_BIRTHDAY"`
  WorkPosition	  string      `json:"WORK_POSITION"`   
  PhoneInner	  string      `json:"UF_PHONE_INNER"`   
  PersonalMobile  string      `json:"PERSONAL_MOBILE"`   
  UFDepartment	  []int	      `json:"UF_DEPARTMENT"`   
}

type BitrixDept	struct {
  ID		  string      `json:"ID"`
  Name		  string      `json:"NAME"`
  Parent	  string      `json:"PARENT"`
  UFHead	  string      `json:"UF_HEAD"`
}

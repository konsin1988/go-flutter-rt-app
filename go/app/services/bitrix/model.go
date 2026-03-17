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

type AbsenceBitrix struct {
    EntityTypeID string		      `json:"entityTypeId"`
    Fields       AbsenceBitrixFields  `json:"fields"`
}

type AbsenceBitrixFields struct {
    CreatedBy     int       `json:"createdBy"`
    CreatedTime   string    `json:"createdTime"`
    UpdatedTime   string    `json:"updatedTime"`
    StageID       string    `json:"stageId"`
    UfCrm14_1629993971 string `json:"ufCrm14_1629993971"`
    UfCrm14_1629994007 string `json:"ufCrm14_1629994007"`
    UfCrm14_1629994024 int    `json:"ufCrm14_1629994024"`
    UfCrm14_1629994055 int    `json:"ufCrm14_1629994055"`
    UfCrm14_1629994264 string `json:"ufCrm14_1629994264"`
}

type BitrixResponse struct {
    Result struct {
      Item struct {
        ID int32   `json:"id"`
      } `json:"item"`
    } `json:"result"`
}


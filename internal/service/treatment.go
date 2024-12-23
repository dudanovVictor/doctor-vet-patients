package service

import (
	"context"

	"github.com/isaydiev86/doctor-vet-patients/internal/dto"
)

func (s *Service) GetTreatments(ctx context.Context, filter dto.TreatmentFilters) ([]*dto.Treatment, error) {
	return s.svc.DB.GetTreatments(ctx, filter)
}

func (s *Service) GetTreatment(ctx context.Context, id int64) (*dto.TreatmentDetail, error) {
	return s.svc.DB.GetTreatment(ctx, id)
}

//func (s *Service) Tx(ctx context.Context, f func(any) error) error {
//	return s.svc.DB.Tx(ctx, f)
//}

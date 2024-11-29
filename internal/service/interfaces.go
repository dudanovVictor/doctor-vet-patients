package service

import (
	"context"

	"doctor-vet-patients/internal/dto"
)

type Database interface {
	GetTreatments(ctx context.Context) ([]*dto.Treatment, error)
	GetTreatment(ctx context.Context, id int64) (*dto.TreatmentDetail, error)
	CreatePatient(ctx context.Context, patient dto.Patient) error
}

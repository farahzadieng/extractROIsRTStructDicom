# extractRS

A MATLAB toolkit for extracting and processing pelvis region-of-interest (ROI) structures from DICOM CT/MRI medical imaging data and radiotherapy structure sets.

## Features

- **DICOM file scanning**: Automatically traverse DICOM directories and extract CT/MRI images
- **Structure extraction**: Extract radiotherapy structure sets (RTSTRUCT) with pelvis anatomy
- **Multi-modality support**: Works with both CT and MR imaging modalities
- **Image registration**: Register and align diagnostic images with radiotherapy data
- **Artifact removal**: Automated seeding and artifact removal algorithms
- **Resolution normalization**: Standardize image resolution for consistent processing
- **ROI extraction**: Isolate and mask specific anatomical structures
- **NIfTI export**: Convert processed data to NIfTI format for downstream analysis

---

## Core Functions

| Function | Purpose |
|----------|---------|
| **GetDicomList.m** | Scan directory and list all DICOM files |
| **GetCTImage.m** | Load and process CT images |
| **GetMRs.m** | Load and process MR images |
| **GetRS.m** | Extract radiotherapy structure sets (RTSTRUCT) |
| **BuildCT.m** | Construct 3D CT volume from 2D slices |
| **RegistRD.m** | Register diagnostic images with planning data |
| **MaskStructures.m** | Create binary masks for extracted ROIs |
| **RSImage.m** | Visualize structures overlaid on images |
| **deArtifactCTSeeding.m** | Remove artifacts using seeding methods |
| **deResoloutionizeCT.m** | Normalize CT image resolution |
| **deResoloutionizeRS.m** | Resample structure sets to target resolution |
| **deterCut.m** | Determine anatomical boundaries/cuts |
| **VerifyUID.m** | Validate DICOM UIDs for consistency |
| **writeNiftiFiles.m** | Export processed data to NIfTI format |

---

## Workflow

```
DICOM Directory
      ↓
GetDicomList → Scan for CT/MRI/RTSTRUCT files
      ↓
GetCTImage / GetMRs → Load medical images
      ↓
BuildCT → Create 3D volume
      ↓
GetRS → Extract structure sets
      ↓
RegistRD → Register images
      ↓
MaskStructures → Create ROI masks
      ↓
deArtifactCTSeeding → Remove artifacts
      ↓
deResoloutionize* → Normalize resolution
      ↓
writeNiftiFiles → Export to NIfTI
```

---

## Requirements

- **MATLAB** R2015b or later
- **Image Processing Toolbox**
- **Parallel Computing Toolbox** (optional, for batch processing)

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/farahzadieng/extractRS.git
   cd extractRS
   ```

2. Ensure MATLAB is installed with required toolboxes

3. Add the repository to your MATLAB path:
   ```matlab
   addpath(genpath('/path/to/extractRS'))
   ```

---

## Usage

### Basic Workflow

Run the main script:

```matlab
main.m
```

The script will:
1. Scan DICOM directories for imaging data
2. Extract CT, MR, and RTSTRUCT files
3. Build 3D volumes and register structures
4. Create anatomical ROI masks for pelvis anatomy
5. Export results as NIfTI files

### Input Data Structure

Organize your DICOM data as follows:

```
data/
├── patient_001/
│   ├── CT_Planning/
│   │   ├── 001.dcm
│   │   ├── 002.dcm
│   │   └── ...
│   ├── MR_Diagnostic/
│   │   ├── 001.dcm
│   │   └── ...
│   └── RTSTRUCT/
│       └── RS.001.dcm
├── patient_002/
│   └── ...
```

### Output Format

Generates NIfTI (.nii.gz) files containing:
- **CT volumes**: 3D CT image arrays
- **MR volumes**: 3D MR image arrays
- **ROI masks**: Binary masks for extracted pelvis structures (prostate, bladder, rectum, femurs, etc.)
- **Registered structures**: Aligned structure sets in volumetric format

---

## Key Algorithms

### Artifact Removal
Uses seeding-based methods to identify and remove imaging artifacts from CT scans, ensuring clean volumetric data.

### Resolution Normalization
Automatically resamples images and structures to a consistent voxel size for standardized analysis across datasets.

### Image Registration
Aligns diagnostic (CT/MR) images with planning structures using rigid and deformable registration techniques.

### ROI Masking
Converts vector-based RTSTRUCT contours into binary volumetric masks for computational analysis.

---

## Applications

- **Radiotherapy planning**: Extract anatomical structures for treatment planning
- **Prostate cancer**: Segment prostate, bladder, rectum, and femurs
- **Gynecologic cancer**: Extract pelvic anatomy for organ-at-risk (OAR) analysis
- **Image-guided intervention**: Register diagnostic and planning images for guidance
- **Research**: Generate annotated datasets for machine learning and deep learning
- **Quality assurance**: Verify structure contours and anatomical accuracy

---

## Known Limitations

- Designed specifically for **pelvis anatomy** (not general-purpose medical imaging)
- Requires **clean, properly organized DICOM data** with consistent naming conventions
- Manual parameter tuning may be needed for different CT/MR acquisition protocols
- **MATLAB-only** implementation (platform-dependent)
- No graphical user interface (CLI-based workflow)
- Limited error handling for corrupted or incomplete DICOM datasets

---

## Troubleshooting

### DICOM files not recognized
- Verify files are in valid DICOM format (.dcm extension)
- Check directory structure matches expected layout
- Ensure MATLAB has proper file read permissions

### Memory issues with large datasets
- Reduce number of slices processed per batch
- Use Parallel Computing Toolbox for distributed processing
- Increase MATLAB memory allocation

### Registration failures
- Verify CT and MR images have overlapping anatomy
- Check that structure sets correspond to correct imaging series
- Adjust registration parameters in configuration

---

## Future Improvements

- [ ] Add support for additional anatomical regions beyond pelvis
- [ ] Implement automated structure quality checks and validation
- [ ] Create Python wrapper for broader accessibility
- [ ] GPU acceleration for faster processing
- [ ] Interactive GUI for structure visualization and editing
- [ ] Expand multi-sequence MR analysis
- [ ] Batch processing for large-scale datasets
- [ ] Comprehensive unit tests and validation suite

---

## Author

Email: farahzadiphy@gmail.com  

---

## Citation

If you use extractRS in your research, please cite:

```
Farahzadi, M. (2024). extractRS: MATLAB toolkit for pelvis ROI extraction from medical imaging.
Available at: https://github.com/farahzadieng/extractRS
```

---

## Support

For issues, questions, or contributions, please open an issue on GitHub or contact the author directly.
